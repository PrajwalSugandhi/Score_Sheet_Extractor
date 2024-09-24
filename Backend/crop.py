import TableExtractor as te
import crop_rollno as crproll
import cv2
from PIL import Image


class Crop:
    def __init__(self):
        self.crop_image("AppClickedImage.jpg","AppClickedImagehalf.jpg")
        path_to_image = "AppClickedImagehalf.jpg"
        # path_to_image = "D:/Smart Score/API/10_perspective_corrected.jpg"
        cropr = crproll.Croproll()
        cropr.main()
        table_extractor = te.TableExtractor(path_to_image)
        perspective_corrected_image = table_extractor.execute()

    def crop_image(self,input_image_path, output_image_path):
        # Open the image
        with Image.open(input_image_path) as img:
            # Crop the image using the crop_area (left, upper, right, lower)
            width, height = img.size
            crop_box = (30, height//2-400, width , height) 
            cropped_image = img.crop(crop_box)
            # Save the cropped image
            cropped_image.save(output_image_path)