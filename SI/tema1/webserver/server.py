import os
import simplejson
import traceback
import re

from flask import Flask, request, render_template, redirect, url_for, send_from_directory
from flask_bootstrap import Bootstrap
from werkzeug.utils import secure_filename


app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'data/'
app.config['MAX_CONTENT_LENGTH'] = 1 * 1024 * 1024

ALLOWED_EXTENSIONS = set(['txt'])

bootstrap = Bootstrap(app)


class uploadfile():
    def __init__(self, name, type=None, size=None, not_allowed_msg=''):
        self.name = name
        self.type = type
        self.size = size
        self.not_allowed_msg = not_allowed_msg
        self.url = "data/%s" % name


    def get_file(self):
        if self.type != None:
            # POST an normal file
            if self.not_allowed_msg:
                return {"name": self.name,
                        "type": self.type,
                        "size": self.size, 
                        "url": self.url,}

            # File type is not allowed
            else:
                return {"error": self.not_allowed_msg,
                        "name": self.name,
                        "type": self.type,
                        "size": self.size,}



class bcolors:
    BLUE = '\x1B[44m'
    CYAN = '\x1B[46m'
    GREEN = '\x1B[42m'
    MAGENTA = '\x1B[45m'
    WHITE = '\x1B[47m'
    RED = '\x1B[41m'
    BLACK = '\x1B[40m'
    YELLOW = '\x1B[43m'
    END = '\x1B[0m'



def replace_pattern(pattern, data, subst):
	for match in re.finditer(pattern, data):
		for i in range(match.span()[0], match.span()[1]):
			data = data[:i] + subst + data[i + 1:]

	return data


def process_tree(data):

	data = replace_pattern(r"\^ +\^", data, '^')
	data = replace_pattern(r"\| +\|", data, '|')
	data = replace_pattern(r"\/ +\\", data, '/')

	data = data.replace('~', bcolors.RED + ' ' + bcolors.END)
	data = data.replace('`', bcolors.BLUE + ' ' + bcolors.END)
	data = data.replace('*', bcolors.MAGENTA + ' ' + bcolors.END)
	data = data.replace('&', bcolors.WHITE + ' ' + bcolors.END)
	data = data.replace('+', bcolors.CYAN + ' ' + bcolors.END)
	data = data.replace('^', bcolors.YELLOW + ' ' + bcolors.END)
	data = data.replace('|', bcolors.BLACK + ' ' + bcolors.END)
	data = data.replace('/', bcolors.GREEN + ' ' + bcolors.END)
	data = data.replace('\\', bcolors.GREEN + ' ' + bcolors.END)

	return data


def send_to_tty(filename):
	data = open(filename).read()
	os.system('echo "\n{}" > /dev/pts/7'.format(process_tree(data)))


def allowed_file(filename):
	return '.' in filename and \
		filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def gen_file_name(filename):
	i = 1
	while os.path.exists(os.path.join(app.config['UPLOAD_FOLDER'], filename)):
		name, extension = os.path.splitext(filename)
		filename = '%s_%s%s' % (name, str(i), extension)
		i += 1

	return filename


@app.route("/upload", methods=['GET', 'POST'])
def upload():
	if request.method == 'POST':
		files = request.files['file']

		if files:
			filename = secure_filename(files.filename)
			filename = gen_file_name(filename)
			mime_type = files.content_type

			if not allowed_file(files.filename):
				result = uploadfile(name=filename, type=mime_type, size=0, not_allowed_msg="File type not allowed")

			else:
				uploaded_file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
				files.save(uploaded_file_path)
				send_to_tty(uploaded_file_path)

				size = os.path.getsize(uploaded_file_path)
				result = uploadfile(name=filename, type=mime_type, size=size)
			
			return simplejson.dumps({"files": [result.get_file()]})

	return redirect(url_for('index'))

@app.route("/data/<string:filename>", methods=['GET'])
def get_file(filename):
	return send_from_directory(os.path.join(app.config['UPLOAD_FOLDER']), filename=filename)


@app.route('/', methods=['GET', 'POST'])
def index():
	return render_template('index.html')


if __name__ == '__main__':
	app.run(debug=True)
