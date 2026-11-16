# Woof Am I: Dog Breed Identifier

An iOS app that identifies a dog's breed from a photo. Take a picture or pick one from your library, and an on-device machine learning model returns the breed in a couple of seconds, along with care information for that breed.

Built as my final-year capstone project (CE301) at the University of Essex, 2023–24. It covers the whole path from training a model in Python to shipping it inside a working mobile app.

## Screenshots

<!-- Add screenshots to docs/screenshots/ and update the paths below. -->

| Camera | Result | History | Community |
|---|---|---|---|
| _screenshot_ | _screenshot_ | _screenshot_ | _screenshot_ |

## What the app does

- **Camera tab:** capture a photo or upload one from the photo library. The model classifies it on the device, with no network call.
- **Result page:** shows the predicted breed, plus breed characteristics (size, exercise, grooming, lifespan and so on) and a link to the breed's page on The Kennel Club website. You can give the dog a name and save the scan.
- **History tab:** past scans are stored locally and can be reopened.
- **Community tab:** enter a postcode, or use your current location, to find nearby vets and animal shelters on a map.

## Tech stack

| Part | Technology |
|---|---|
| App | Swift 5, SwiftUI with some UIKit, Xcode 15, iOS 17.2+ |
| On-device inference | Core ML and Vision |
| Camera and photo picker | AVFoundation, UIImagePickerController |
| Scan history | Core Data |
| Maps and location | MapKit, CoreLocation |
| Model training | Python, TensorFlow 2.14 / Keras, Jupyter |
| Model conversion | coremltools 7.1 |
| Breed information | BeautifulSoup web scraping into a bundled JSON file |

## How the model works

The classifier is a transfer-learning model built on **InceptionV3** pretrained on ImageNet, trained on the **Stanford Dogs** dataset (20,580 images of 120 breeds).

1. **Data preparation.** Images are split roughly 70/20/10 into training, validation and test folders, then resized to 224×224 and rescaled to the 0–1 range. The training set is augmented with horizontal flips and width and height shifts.
2. **Feature extraction.** The InceptionV3 base (without its ImageNet classification head) is frozen. A new head is added on top: flatten, dropout of 0.5, and a softmax layer with L2 regularisation. Only the head is trained, for 3 epochs with Adam.
3. **Fine-tuning.** The last 10 layers of the base are unfrozen and training continues for 5 more epochs at a much lower learning rate (1e-5).
4. **Conversion.** The Keras model is converted to a Core ML package with `coremltools`, with the class labels and image preprocessing built in, so the app can pass a camera image straight to it.

In the app, [`DogBreedClassifier.swift`](WoofAmI_Capstone/Dog%20Breed%20Recognition%20Model/DogBreedClassifier.swift) wraps the model in a Vision request, runs it off the main thread, and returns the top label and its confidence. The label is then mapped to a Kennel Club breed name to look up the breed details.

### Results

| Metric | Value |
|---|---|
| Training accuracy (final epoch, with augmentation) | 80.9% |
| Validation accuracy | 86.6% |
| Test accuracy | 87.3% |

These are the figures recorded in [`DogBreedRecognition_model.ipynb`](DogBreedRecognition_model.ipynb). Please read them alongside the limitations below.

### Known limitations

- **The test figure is optimistic.** The notebook re-extracts the dataset and re-runs the random split each time it is executed, without clearing the previous split. Over several runs, most images ended up in more than one split: about 93% of the test images also appear in the training set. The 87.3% is therefore not a true held-out score. A clean split, or the dataset's official train/test lists, would give a lower and more honest number.
- **123 output classes instead of 120.** The `train`, `val` and `test` folders were themselves picked up as class names. They contain no images, so the model never predicts them in practice, but they should be removed in a retrain.
- **Stanford Dogs breeds only.** Mixed breeds and breeds outside the 120 in the dataset are assigned to the closest match.
- **Some breed details are approximate.** Stanford Dogs includes three wild canids (dhole, dingo and African hunting dog) with no Kennel Club page, so the app maps them to the nearest listed breed.

## Repository structure

```
.
├── WoofAmI_Capstone.xcodeproj/          Xcode project
├── WoofAmI_CapstoneApp.swift            App entry point
├── TabMainView.swift                    Tab bar (History, Camera, Community)
├── WoofAmI_Capstone/
│   ├── Camera/                          Capture, photo picker, classification flow
│   ├── Dog Breed Recognition Model/     Core ML and Vision wrapper
│   ├── Detail/                          Result page, breed data (breed_data.json)
│   ├── History/                         Core Data model and history list
│   └── Community/                       Map search for vets and shelters
├── dogBreedRecognitionUpdated.mlpackage Trained Core ML model used by the app (56 MB)
├── Fonts/
├── DogBreedRecognition_model.ipynb      Final training and Core ML conversion notebook
├── DogBreedDetails.ipynb                Scraper that builds breed_data.json
└── notebooks/experiments/               Earlier training experiments, kept for reference
```

## Running the app

Requirements: a Mac with Xcode 15 or later. A physical iPhone running iOS 17.2 or later is needed for the camera; everything else works in the simulator using the photo library.

1. Clone the repository:

   ```bash
   git clone https://github.com/SelinaCCY/dog-breed-recognition-iOS-app.git
   ```

2. Open `WoofAmI_Capstone.xcodeproj` in Xcode.
3. Under **Signing & Capabilities**, select your own development team.
4. Choose a simulator or a connected iPhone and press **Cmd + R**.
5. On first launch, allow camera, photo library and location access.

The trained model is included in the repository, so the app builds without running any Python.

## Running the model notebook

You only need this to retrain the model or to see how it was built.

1. Create an environment (Python 3.10 was used) and install the dependencies:

   ```bash
   pip install tensorflow==2.14.0 coremltools==7.1 tensorflow-datasets numpy matplotlib scikit-learn scipy pillow tqdm jupyter
   ```

2. Download the dataset. It is not included here because it is about 800 MB. From the [Stanford Dogs page](http://vision.stanford.edu/aditya86/ImageNetDogs/main.html), download `images.tar` and place it in the same folder as the notebook. The notebook extracts it into an `Images/` folder.
3. Start Jupyter and open `DogBreedRecognition_model.ipynb`:

   ```bash
   jupyter notebook
   ```

4. Run all cells. Training took about 10 minutes per epoch on an Apple Silicon Mac. The notebook saves the Keras model as `dogBreedRecognitionModel.h5` and the Core ML package as `dogBreedRecognitionUpdated.mlpackage`.
5. To use a retrained model in the app, replace `dogBreedRecognitionUpdated.mlpackage` in the repository root with the new one and rebuild.

If you retrain, start from a freshly extracted `Images/` folder and run the split once only, to avoid the overlap described under known limitations.

`DogBreedDetails.ipynb` rebuilds `breed_data.json` and needs `requests` and `beautifulsoup4`.

## Acknowledgements

- **Dataset:** Khosla, Jayadevaprakash, Yao and Fei-Fei, *Novel Dataset for Fine-Grained Image Categorization: Stanford Dogs*, CVPR Workshop on Fine-Grained Visual Categorization, 2011.
- **Base model:** InceptionV3, via Keras Applications.
- **Breed information:** collected from [The Kennel Club](https://www.thekennelclub.org.uk/search/breeds-a-to-z/) breed pages. It remains their content and is included here for educational purposes only; each breed links back to its source page.
- **Fonts:** Caveat and Comic Neue, both under the SIL Open Font License.
- Tutorials and references that individual files were adapted from are credited in comments at the top of those files.
