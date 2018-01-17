import requests
import sys
from functools import partial

endpoints = {
"rhyme": "rel_rhy",
"adjectives": "rel_jjb",
"trigger" : "rel_trg",
"sounds_like": "sl"
}

def api_call(word, max_responses = None, syllables = None, starts_with = None, randomize = False, call = "rhyme"):
    '''Queries the datamuse API with a given call.

    Example:

    Jack and jill
    went up the {}
    """.format(rhymer.rhymes_with("hill", syllables = 2, randomize = True, max_responses = 1))
    '''

    try:
        end = endpoints[call]
    except:
        sys.exit(repr("I don't understand {}".format(call)))

    response = requests.get("http://api.datamuse.com/words" + '?{end}={w}'.format(end = end, w = word))
    data = response.json()

    ## here:
    ## sort dict by score
    ## return only words with the appropriate number of sylabbles

    to_return = []

    if syllables is not None:
        try:
            data = [ datum for datum in data if datum["numSyllables"] == syllables]
        except KeyError:
            print("quite note: {} doesn't work with syllables. Ignoring.\n".format(call))

    for datum in data:
        to_return.append(datum['word'])

    if starts_with is not None:
        to_return = [x for x in to_return if x.lower().startswith(starts_with.lower())]

    if randomize:
        from random import shuffle
        shuffle(to_return)

    if max_responses is not None:
        to_return = to_return[:max_responses]

    return '/'.join(to_return)

# probably a more concise way to do this using map
sounds_like = partial(api_call, call = "sounds_like")
related_to = partial(api_call, call = "trigger")
rhymes_with = partial(api_call, call = "rhyme")
with_adjectives = partial(api_call, call = "adjectives")
