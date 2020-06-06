import firebase_admin
from firebase_admin import messaging
from firebase_admin import credentials

if not firebase_admin._apps:
  cred = credentials.Certificate('path_to_json_credentials')
  firebase_admin.initialize_app(cred)

# The topic name can be optionally prefixed with "/topics/".
topic = 'update_runs'


# See documentation on defining a message payload.
message = messaging.Message(
    data={
        'title': 'FCM Message',
        'body': 'This is an FCM notification message to device N!',
    },
    topic=topic,
)


# Send a message to the devices subscribed to the provided topic.
response = messaging.send(message)
# Response is a message ID string.
print('Successfully sent message:', response)