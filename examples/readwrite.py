"""
    class to remount SD card parts readwrite and remount them readonly

    how to use:

    import readwrite

    # ...

    with ReadWrite('/') as rw:
        # now you can open and write files.
        open("example.txt", "w") as f:
            # ...

    # now you are back in read-only mode once you exited
    # the with block

    I'd recommend being a bit careful where you use this class,
    as there is no protection if you have more than one process
    trying to enter a ReadWrite block at the same or overlapping times.
    Doing so is unlikely to end well.

    Note this doesn't do you much good by itself when the file must be
    opened as super user.  In that case I usually use subprocess.run()
    with sudo to make filesystem changes.  Inside a ReadWrite block.

    On a normal pi, either ReadWrite('/') or ReadWrite('/boot') make sense.
    Nothing else will.
"""

import subprocess

# rw_command = ["sudo", "mount", "-o", "remount,rw", "/boot"]
# ro_command = ["sudo", "mount", "-o", "remount,ro", "/boot"]


class ReadWrite:
    def __init__(self, path):
        self._path = path

    def __enter__(self):
        cmd = ["sudo", "mount", "-o", "remount,rw", self._path]
        subprocess.run(cmd)

    def __exit__(self, exc_type, exc_val, exc_tb):
        cmd = ["sudo", "mount", "-o", "remount,ro", self._path]
        subprocess.run(cmd)
