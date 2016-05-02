#!/usr/bin/env bash

PHRASES=(
  'You are doing great, Caitlin.'
  'Are you really living up to your full potential?'
  'Always be better.'
  'Time to get to work.'
  'That last hour was quite productive! Great job at allocating your time.'
  'You are doing great, Caitlin. Just a few more hours until quitting time. Can't wait.'
  'Awesome job. Keep up the good work.'
  'Yolo.'
)

VOICE=(
    'Samantha'
    'Princess'
    'Moira'
    'Karen'
    'Bruce'
    'Alex'
    'Good News'
)

rand=$[ $RANDOM % ${#PHRASES[@]} ]
rand2=$[ $RANDOM % ${#VOICE[@]} ]
RANDOM_PHRASE=${PHRASES[$rand]}
RANDOM_VOICE=${VOICE[$rand2]}

echo $RANDOM_PHRASE
echo $RANDOM_VOICE

say $RANDOM_PHRASE -v $RANDOM_VOICE; exit
