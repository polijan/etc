#!/usr/bin/env python
# -*- coding: utf-8 -*-

__program__ = 'Pyre'
__version__ = '0.5.0'
__description__ = 'Terminal fire'
__author__ = 'Brandon Dreager'
__author_email__ ='pyre@subol.es'
__copyright__ = 'Copyright (c) 2016 Brandon Dreager'
__license__ = 'MIT'
__website__ = 'https://github.com/Regaerd/Pyre'

import curses, random, os

class Pyre(object):
    kPALETTE = list(' .:^*xsS#$')
    kDEFAULT_COLORS = [215, 172, 196, 235]
    kDEFAULT_COLORS_FALLBACK = [0, 1, 3, 4]

    kMIN_INTENSITY = 1
    kCOLOR_RANGE = 4

    def __init__(self, stdscr):
        self._intensity = self._colors = None
        self._auto_intensity = True
        self.stdscr = stdscr

        try:
            self.colors = self.kDEFAULT_COLORS
        except: # means the terminal doesn't support 256 colors
            self.colors = self.kDEFAULT_COLORS_FALLBACK

        self.random_change = False
        self.smooth_change = False
        self.verbose = False

    @property
    def intensity(self): return self._intensity
    @intensity.setter
    def intensity(self, value):
        self._intensity = value if value > self.kMIN_INTENSITY else self._intensity

    @property
    def auto_intensity(self): return self._auto_intensity
    @auto_intensity.setter
    def auto_intensity(self, value):
        self._auto_intensity = value
        if self._auto_intensity: self.intensity = self.height * 3

    @property
    def colors(self): return self._colors
    @colors.setter
    def colors(self, value):
        self._colors = value
        [curses.init_pair(i+1, self._colors[i], -1) for i in range(self.kCOLOR_RANGE)]

    def start(self):
        self.view_resized()

    def update(self):
        try: # needed to draw last character, which will ERR
            for i in range(int(self.width/9)):
                self.buffer[int((random.random()*self.width)+self.width*(self.height-1))]=self.intensity

            for i in range(self.size):
                result=int((self.buffer[i]+self.buffer[i+1]+self.buffer[i+self.width]+self.buffer[i+self.width+1])/4)
                self.buffer[i] = result
                self.render(i, result)
        except: pass

        if self.random_change and not random.randint(0, 100):
            self.update_color(random.randint(0, self.kCOLOR_RANGE))

        if self.verbose:
            self.stdscr.clrtoeol()
            self.stdscr.addstr(0,0,'colors:{}, intensity:{}, height:{}'.format(self.colors, self.intensity, self.height))

        self.stdscr.refresh()

    def update_color(self, i):
        try: # needed for terminals that don't support 256 colors
            self.colors[i] = sorted((11, self.colors[i]-1 if random.randint(0,1) else self.colors[i]+1, 255))[1] if self.smooth_change else random.randint(0,255)
            curses.init_pair(i+1, self.colors[i], -1)
        except: pass

    def render(self, index, buffer):
        self.stdscr.addch(index/self.width,
                          index%self.width,
                          self.kPALETTE[(9 if buffer>9 else buffer)],
                          curses.color_pair(4 if buffer>15 else (3 if buffer>9 else (2 if buffer>4 else 1))))

    def view_resized(self):
        self.height, self.width = self.stdscr.getmaxyx()
        self.size = self.width * self.height
        self.buffer = [0] * (self.size+self.width+1)
        if self.auto_intensity: self.intensity = self.height * 3

    def random_colors(self):
        try: # needed for terminals that don't support 256 colors
            self.colors = [random.randint(0,255) for i in range(self.kCOLOR_RANGE)]
        except: pass

    def change_intensity(self, amt):
        self.intensity += amt
        self.auto_intensity = False

    def toggle_smooth_change(self):
        self.smooth_change = not self.smooth_change
        if self.smooth_change: self.random_change = True

class Driver(object):
    kKEY_ESC = '\x1b'

    def __init__(self, stdscr):
        self.stdscr = stdscr
        curses.curs_set(0)
        curses.use_default_colors()
        self.stdscr.nodelay(1)

        self.fire = Pyre(stdscr)

        self.running = False

    def start(self):
        self.running = True
        self.fire.start()
        self.run()

    def run(self):
        while self.running:
            self.fire.update()
            self.update()
            self.stdscr.timeout(50)

    def update(self):
        try:
            key = self.stdscr.getkey()
        except curses.error as e:
            if str(e) == 'no input': return
            raise e

        lower = key.lower()
        if key == 'KEY_RESIZE': self.fire.view_resized()
        elif key==self.kKEY_ESC or lower=='q': self.running = False
        elif lower=='v': self.fire.verbose = not self.fire.verbose
        elif lower=='c': self.fire.random_colors()
        elif lower=='i': self.fire.auto_intensity = not self.fire.auto_intensity
        elif lower=='t': self.fire.random_change = not self.fire.random_change
        elif lower=='s': self.fire.toggle_smooth_change()
        elif key==',' or key=='<': self.fire.change_intensity(-1)
        elif key=='.' or key=='>': self.fire.change_intensity( 1)

def main(stdscr=None):
    if not stdscr: curses.wrapper(main)
    else:
        os.environ.setdefault('ESCDELAY', '25')
        Driver(stdscr).start()

if __name__ == '__main__': main()
