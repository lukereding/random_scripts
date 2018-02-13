import re
import sys

'''

Goal: Save all single copy transcripts and the largest copy of multi-copy transcripts to a file called output.txt.

Run like: python write_transcripts_version2.py path/to/transcipts

Creates output.txt.

Assumes the file holding all the transcripts is large and thus cannot be read into memory.
The script uses generators to sweep through the transcript file multiple times instead.
Thus memory useage is lower but it will be somewhat slow.

Created: 13 February 2018
Luke Reding

'''

def save_single_copy_transcipts(all_transcript_file):
    f = open(all_transcript_file, 'r')
    output_file = open("output.txt", 'a')
    # create a generator to read in the file one line at a time
    lines = (line for line in f)
    line = next(lines)
    while True:
        try:
            if re.match(r'>Locus_\d+_Transcript_1/1_+.*?\n', line) is not None:

                # write the header
                output_file.write(line)

                line = next(lines)

                # write the sequence
                while True:
                    if re.match(r'^[ATGCN]+\n$', line) is not None:
                        # pdb.set_trace()
                        # print(line)
                        output_file.write(line)
                        line = next(lines)
                    else:
                        break
            else:
                line = next(lines)

        # break the loop at the end of the file
        except:
            break
    output_file.close()
    f.close()


def get_numeric(x):
    y = x.replace(r"[a-zA-Z_]",'')
    return int(y)

# generate a list of all the transcipts with multiple find_copies

def find_transcripts_multiple_copies(all_transcript_file):
    '''Returns a dict where the keys are names of loci and the values are the corresponding headers.'''
    f = open(all_transcript_file, 'r')
    lines = (line for line in f)
    line = next(lines)
    headers = []
    loci = []
    while True:
        try:
            if len(re.findall(r'>.*?[0-9]/(?:[2-9]|[1-9][0-9]+)_.*Length_[0-9]+?\n', line)) > 0:
                headers.append(line)
                loci.append(re.findall(r'>Locus_(\d+)_', line)[0])
            line = next(lines)
            # pdb.set_trace()
        except:
            break
    d = {}
    for l, h in zip(loci, headers):
        if l in d.keys():
            d[l].append(h)
        else:
            d[l] = [h]

    return d

def find_largest_match(list_of_loci):
    lengths = []
    for locus in list_of_loci:
        # grab the Length
        num = get_numeric(locus.split("Length_")[1])
        lengths.append(num)
    # note: if there are two transcripts of equal length, the first one will by chosen
    index_of_largest = lengths.index(max(lengths))
    return(list_of_loci[index_of_largest])


def write_largest_match(header, all_transcript_file):
    output_file = open("output.txt", 'a')
    f = open(all_transcript_file, 'r')
    lines = (line for line in f)
    line = next(lines)
    stop = False
    while stop == False:
        try:
            if line == header:
                output_file.write(line)
                line = next(lines)
                while re.match(r'^[ATGCN]+\n$', line) is not None:
                    print(line)
                    output_file.write(line)
                    line = next(lines)
                else:
                    output_file.close()
                    f.close()
                    stop = True
                    break
            else:
                line = next(lines)
        except:
            break

if __name__ == "__main__":

    transcripts_file = sys.argv[1]

    # write the largest transcipt to the output file
    save_single_copy_transcipts(transcripts_file)

    loci_header_dict = find_transcripts_multiple_copies(transcripts_file)

    largest_matches = []
    for transcript_number, headers in loci_header_dict.items():
        largest_matches.append(find_largest_match(headers))

    print(largest_matches)

    for header in largest_matches:
        write_largest_match(header, transcripts_file)
