"""
trust_notebooks.py Walk through a given directory and execute trust on
each Jupyter notebook found there.
Tue Feb 15, 2022 12:55 PM
"""

import os, sys
import getopt

def main(argv):

    try:

        opts, args = getopt.getopt(argv, "hp")

    except getopt.GetoptError:
        usage()

    for opt, arg in opts:

        if opt == '-h':
            usage()
        elif opt == "-p":
            try:
                process_files()
            except FileNotFoundError:
                print("Path incorrect. Did you quote the path string? If so, try again without the quotes.")

def process_files():
    nb_dir = input("What directory: ")

    if os.path.isdir(nb_dir):
        with os.scandir(nb_dir) as nb:
            for file in nb:
                if file.name.endswith(".ipynb"):
                    os.system('jupyter trust "{}"'.format(file.path))
    else:
        print("Directory not found. Did you remember to not quote the directory string?")
        exit(1)


def usage():
    text="""
    ==========================================================
                   Bulk Trust of Jupyter Notebooks
    ==========================================================
    '{script}'
    -p "Process files"
    -h "This help file"
    Make trusted all the notebooks in a directory. Give an
    absolute path or a path relative to the current directory in
    which the script is executed. Use '.' if the script is
    being run from the target directory.
    NOTE: Do not quote the path even if it contains spaces. That
    will be handled by the script.
    """
    print(text.format(script=os.path.basename(sys.argv[0])))
    exit(1)

if __name__ == "__main__":
    main(sys.argv[1:])
