import os, sys, datetime, argparse, datetime
from os.path import isfile, join

def get_creation_time(path):
    """Get the time of file creation."""
    return os.stat(path).st_birthtime

def get_modification_time(path):
    """Get the time the file was last modified."""
    statinfo = os.stat(path)
    return statinfo.st_mtime

def take_difference(x,y):
    """Discount y from x."""
    return x-y

def get_all_files(path):
    """get all files in path (excluding directories)."""
    onlyfiles = [f for f in os.listdir(path) if isfile(join(path, f))]
    return onlyfiles

def main():
    """main function."""
    # set up argument parser
    ap = argparse.ArgumentParser()
    ap.add_argument("-i", "--path", help = "path to folder", required=True)
    args = ap.parse_args()

    # get the path
    path = args.path

    # make sure it's a path, not a directory
    if not os.path.isdir(path):
        sys.exit("\n\nsupply a directory, not a filename.")

    files = get_all_files(path)

    mod_creation = [take_difference(get_modification_time(file), get_creation_time(file)) for file in files]
    results = zip(files, mod_creation)
    print results
    # l = ["h:m:s: {}".format(str(datetime.timedelta(seconds=y))) for x,y in results]
    # print l


if 'main' in __name__: main()
# seconds = get_modification_time(path) - get_creation_time(path)
# print "{} seconds".format(seconds)
# print "h:m:s: {}".format(str(datetime.timedelta(seconds=seconds)))
