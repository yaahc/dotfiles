#! /usr/bin/env python2.7

import argparse, sys, re, os
import subprocess

INPUT_FILE = os.path.expanduser("~/.piano_lines.out")

def main(argv):
    parser = argparse.ArgumentParser(description="Program to parse output from \
            pianobar for input into LemonBoy's Bar")
    parser.add_argument('-i', '--input-file', default=INPUT_FILE, help="file \
            pianobar's output will be directed to")
    args = parser.parse_args()

    if not testFile(args.input_file):
        print("not test file")
        return 0

    try:
        if False:
            print("do some option")
        else:
            # default behavior
            printDefault(args.input_file)
    except:
        print("Exception in main func")
        return 1

    return 0
    

def testFile(file):
    """
    testFile()
      - file: filename being checked
      
      This method tests a file, checking to see if a process is attached to it.
      The result of this operation is returned (True if a process _is_ attached,
      False otherwise).

      This method executes the 'fuser' command on the command-line, and checks
      to see if there are results.
    """
    p = subprocess.Popen(["fuser", file], stdout=subprocess.PIPE,
            stderr=subprocess.PIPE)
    result = p.communicate()[0]

    return result not in (None, "")

def printDefault(file):
    print(parseSongInfo(file))
    print(printSongTime(file, False))
    print(printAlbum(file, False))
    print(printArtist(file, False))
    print(printSongTitle(file, True, True))
    print(printstation(file, False))

def printstation(file, verbose):
    return "Going to rewrite this one"

def printSongTitle(file, verbose, printAllInfo):
    print("Should rewrite this one")
    """
    printSongTitle()
      - file: path to file being written by Pianobar
      - verbose: setting to print headers
      
      This method attempts to parse out the title of the most recently-played song.  This
      content is buried deep within the content in the file.  This method runs the 'grep'
      command on the command-line against this file, first extracting "|>" lines (which are
      hard-coded in Pianobar to indicate song titles).  It then uses a combination of newline
      and carriage-return parsing to extract the last instance of this string in the file.
    """
    output = parseSongInfo(file)

    if output is not None:
        if not printAllInfo:
            output = output.split("by")[0]
        if verbose:
            output = "Now Playing: %s" % output
        return(output)
    else:
        print(DEFAULT_MSG)

def printArtist(file, verbose):
    """
    printArtist()
      - file: path to file being written by Pianobar
      - verbose: setting to print headers
      
      This method parses out the name of the artist currently playing.  If the
      verbose flag is included, this method includes header information about
      what's playing.
    """
    output = parseSongInfo(file)
    
    if output is not None:
        output = output.split("\"")[3]
        if verbose:
            output = "Artist: %s" % output
        return output
    else:
        print(DEFAULT_MSG)

def printAlbum(file, verbose):
    """
    printAlbum()
      - file: path to file being written by Pianobar
      - verbose: setting to print headers
      
      This method parses out the album currently playing.  If the
      verbose flag is included, this method includes header information
      about what's playing.
    """
    output = parseSongInfo(file)
    if output is not None:
        output = output.split("\"")[5]
        if verbose:
            output = "AlbumL %s" % output
        return output
    else:
        print(DEFAULT_MSG)

def printSongTime(file, verbose):
    """
    printSongTitle()
      - file: path to file being written by Pianobar
      - verbose: setting to print headers
      
      This method opens a new file object using the filepath passed by the
      calling method.  This filehandle is then modified so its position is set
      to 12 bytes prior to the end (yes, hard- coded length, I know).  It then
      reads the following 12 bytes of information, which indicates the time
      remaining in the song.  The file is then closed (which repositions the
      file to the EOF so it writes correctly).
    """
    try:
        with open(file, 'ra') as fileH:
            fileH.seek(-12, 2)
            content = fileH.read(12).rstrip()
            if "/" in content:
                content = "Play time remaining: %s" % content if verbose else content
                return content
            else:
                print(DEFAULT_MSG)

            fileH.close()
    except:
        print("Unexpected error:", sys.exc_info())

def parseSongInfo(file):
    """
    parseSongInfo()
      - file: path to file being written by Pianobar
      
      This method opens the file being written by Pianobar, extracting out the
      most recent song information from the file.  This is a fairly ugly
      process, since tee-ing the streaming information is a combination of '\n'
      and '\r' characters.  There are also superfluous characters and whitespace
      used to designate the various segments of info. This parsed information is
      returned to the calling method.
      
      If any processing or parsing fails, this method will swallow the exception
      and simply return a None value.  I'm not terribly interested in trying to
      figure out _why_ the error happened, but I certainly want to make sure the
      caller can handle it.
    """
    try:
        p = subprocess.Popen(["grep", "|>", file], stdout=subprocess.PIPE,
                stderr=subprocess.PIPE)
        result = str(p.communicate()[0])
        output = result.split("\r")[-1].split("\n")[-2].replace("|>", "")
        output = re.sub("^\s*", "", output)
        # Return None if the output doesn't contain "by"
        return output if "by" in output else None

    except Exception:
        print("Unexpected error:", sys.exc_info())
        return None

if __name__ == '__main__':
    sys.exit(main(sys.argv))
