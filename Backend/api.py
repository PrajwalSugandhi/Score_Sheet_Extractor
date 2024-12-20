from flask import Flask, request
import crop as m
import base64
import updatepredict as Up
import predict_marks as Pm
import json

app = Flask(__name__)


@app.route("/", methods = ["POST"])
async def home():
    data = request.get_json(force=True)
    image_data = data['image']
    imgdata = base64.b64decode(image_data)
    filename = 'AppClickedImage.jpg'
    
    with open(filename, 'wb') as f:
        f.write(imgdata)

    m.Crop()
    
    # Using Github API + SERP API
    predictor = Pm.Predict()
    pre = await predictor.execute()

    #Using Google Vision API
    # predictor = Up.Predict()
    # pre = predictor.execute()


    with open("10_perspective_corrected.jpg", "rb") as imagefile:
        convert = base64.b64encode(imagefile.read())

    pre['image'] = convert.decode()
    json_object = json.dumps(pre) 

    return json_object





if __name__ == '__main__':
        app.run(host='0.0.0.0', debug=True)