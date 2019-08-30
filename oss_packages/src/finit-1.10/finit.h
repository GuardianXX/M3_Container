/* Finit - Extremely fast /sbin/init replacement w/ I/O, hook & service plugins
 *
 * Copyright (c) 2008-2010  Claudio Matsuoka <cmatsuoka@gmail.com>
 * Copyright (c) 2008-2013  Joachim Nilsson <troglobit@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#ifndef FINIT_H_
#define FINIT_H_

#include <errno.h>
#include <fcntl.h>
#include <paths.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#define EMBEDDED_SYSTEM 1 // Todo mei Grampf, eingefuegt
/* Distribution specific configuration */
#if defined EMBEDDED_SYSTEM
# define CONSOLE        _PATH_CONSOLE
# define SETUP_DEVFS        "/sbin/mdev -s"
//# define GETTY          "/sbin/getty -L" // Todo mei Grampf
# define GETTY          "/sbin/getty"
# define GETTY_BUSYBOX
# define BAUDRATE       115200
# define RUNLEVEL       2
#else /* Debian/Ubuntu based distributions */
# define CONSOLE        "/dev/tty1"
# define SETUP_DEVFS        "/sbin/udevd --daemon"
# define GETTY          "/sbin/getty -8"
# define GETTY_AGETTY
# define BAUDRATE       38400
# define RUNLEVEL       2
# define RANDOMSEED     "/var/lib/urandom/random-seed"
# define REMOUNT_ROOTFS_RW
# define HAVE_DBUS
#endif

#ifndef FALLBACK_SHELL
# define FALLBACK_SHELL     _PATH_BSHELL
#endif

#ifndef DEFUSER
# define DEFUSER        "root"
#endif
#ifndef DEFHOST
# define DEFHOST        "noname"
#endif

/* Delay start of GETTY at boot. Must be > 0 */
#define DELAY_TTY       2

#define CMD_SIZE        256
#define LINE_SIZE       1024
#define BUF_SIZE        4096

#define INIT_MAGIC      0x03091969
#define INIT_CMD_RUNLVL     1
#define INIT_CMD_DEBUG      2
#define INIT_CMD_RESTART    3 // Todo mei Grampf
#define INIT_CMD_STOP       4 // Todo mei Grampf
#define INIT_CMD_START      5 // Todo mei Grampf

struct init_request {
    int magic;      /* Magic number         */
    int cmd;        /* What kind of request     */
    int runlevel;   /* Runlevel to change to    */
    int sleeptime;  /* Time between TERM and KILL   */
    char    data[368];
};

extern int    runlevel;
extern int    cfglevel;
extern int    prevlevel;
extern char  *sdown;
extern char  *network;
extern char  *hostname;
extern char  *username;
extern char  *rcsd;
extern char  *console;
extern char  *__progname;

/* conf.c */
int parse_runlevels  (char *runlevels);
int parse_finit_conf (char *file);

#endif /* FINIT_H_ */

/**
 * Local Variables:
 *  version-control: t
 *  indent-tabs-mode: t
 *  c-file-style: "linux"
 * End:
 */
