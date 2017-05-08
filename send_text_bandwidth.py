import bandwidth
import os

'''
Send text mesages using Bandwidth's Python API.
'''

message = '''Here there {}. Nice to meet you.'''.format("Luke")

token = os.environ['BANDWIDTH_TOKEN']
secret = os.environ['BANDWIDTH_SECRET']

messaging_api = bandwidth.client('catapult', 'u-xa4jbh3abw5dmkjyeidr5ka', token, secret)

message_id = messaging_api.send_message(from_ = '+15129005433',
                              to = '+11231231234',
                              text = message)

# send bulk text
# results = messaging_api.send_messages([
#     {'from': '+1234567980', 'to': '+1234567981', 'text': 'SMS message'},
#     {'from': '+1234567980', 'to': '+1234567982', 'text': 'SMS message2'}
# ])

