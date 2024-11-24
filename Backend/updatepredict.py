import os,io
from google.cloud import vision
import cv2

class Predict:

    def __init__(self):
        os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = r'secretkey.json'

        # Initialize the client
        self.client = vision.ImageAnnotatorClient()


    def execute(self):
        self.resize()
        dict = self.predictmarks()
        dict['rollnum'] = self.predictroll()
        print(dict)
        return dict


    def resize(self):
        img = cv2.imread("10_perspective_corrected.jpg")
        rows, cols, _ = img.shape
        x = int(rows / 12)
        y = int(cols / 2)

        cut_image = img[1 * x:12 * x, y:2 * y]
        resized_image = cv2.resize(cut_image, (120, 600))
        print('resized successfully')
        cv2.imwrite("resized_image.jpg", resized_image)


    def predictmarks(self):


        with io.open("resized_image.jpg", "rb") as image_file:
            content = image_file.read()

        # Construct the image object
        image = vision.Image(content=content)

        # hint for api
        image_context = vision.ImageContext(language_hints=["en"]) 

        # Call the API
        response = self.client.text_detection(image=image, image_context=image_context)

        # Print detected text
        texts = response.text_annotations
        if(len(texts)==0):
            return {}
        marks = texts[0].description.split()
        # print(marks)

        data_dict = {}

        for i in range(0, len(marks)):
            try:
                data_dict[i + 1] = marks[i]
            except (IndexError, ValueError) as e:
                print(e)

        return data_dict


    def predictroll(self):
        with io.open("cropped_roll.jpg", "rb") as image_file:
            content = image_file.read()

        # Construct the image object
        image = vision.Image(content=content)

        # Call the API
        response = self.client.text_detection(image=image)

        # Print detected text
        texts = response.text_annotations
        if(len(texts)==0):
            return ""
        roll = texts[0].description.split()
        # print(roll)
        rollno=""
        flag=0
        for i in roll:
            if(flag==1):
                rollno+=i
            if(i[0]=="N" and i[1]=="o"):
                flag=1

        return rollno