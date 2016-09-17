#!/home/pi/jasper/python/bin/python

import tempfile
import pyvona
v = pyvona.create_voice('GDNAIRQTKTUWEAXAPFRA', 'gr1/8h7Tv7UgevPdlPs0abyjTWNHC0XrnZTUtEbZ')
#v.speak('Hello Emanuele')
v.codec = "mp3"

with tempfile.NamedTemporaryFile(suffix='.mp3', delete=False) as f:
    tmpfile = f.name
    print('Saving audio on %s' % tmpfile)
    
v.fetch_voice('Hello', tmpfile)
