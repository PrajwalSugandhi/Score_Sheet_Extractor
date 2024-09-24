from PIL import Image

class Croproll:
    def main(self):
        self.resize_image('AppClickedImage.jpg', 'resized.jpg', (588, 822))
        self.crop_image('resized.jpg', 'cropped_roll.jpg', (50, 430, 350, 500))
        self.resize_image('cropped_roll.jpg', 'cropped_roll.jpg', (281,63))

    def resize_image(self,input_image_path, output_image_path, new_size):
        # Open the image
        with Image.open(input_image_path) as img:
            # Resize the image
            resized_image = img.resize(new_size)
            # Save the resized image
            resized_image.save(output_image_path)

    def crop_image(self,input_image_path, output_image_path, crop_area):
        # Open the image
        with Image.open(input_image_path) as img:
            # Crop the image using the crop_area (left, upper, right, lower)
            cropped_image = img.crop(crop_area)
            # Save the cropped image
            cropped_image.save(output_image_path)









# def enhance_image_quality(input_image_path, output_image_path, enhancement_factor):
#     # Open the image
#     with Image.open(input_image_path) as img:
#         # Enhance sharpness
#         enhancer = ImageEnhance.Sharpness(img)
#         enhanced_image = enhancer.enhance(enhancement_factor)
        
#         # Save the enhanced image
#         enhanced_image.save(output_image_path)

# enhance_image_quality('cropped_init.jpg', 'cropped_init.jpg', 2)