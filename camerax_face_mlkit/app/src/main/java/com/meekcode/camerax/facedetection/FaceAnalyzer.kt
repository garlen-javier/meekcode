package com.meekcode.camerax.facedetection

import android.annotation.SuppressLint
import android.media.Image
import android.util.Log
import android.util.Size
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import androidx.lifecycle.Lifecycle
import com.google.android.gms.tasks.OnFailureListener
import com.google.android.gms.tasks.OnSuccessListener
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.face.Face
import com.google.mlkit.vision.face.FaceDetection
import com.google.mlkit.vision.face.FaceDetectorOptions

class FaceAnalyzer(lifecycle: Lifecycle, private val overlay: Overlay) : ImageAnalysis.Analyzer {

    private val options = FaceDetectorOptions.Builder()
        .setPerformanceMode(FaceDetectorOptions.PERFORMANCE_MODE_ACCURATE)
        .setLandmarkMode(FaceDetectorOptions.LANDMARK_MODE_ALL)
        .setContourMode(FaceDetectorOptions.CONTOUR_MODE_ALL)
        .setClassificationMode(FaceDetectorOptions.CLASSIFICATION_MODE_ALL)
        .setMinFaceSize(0.15f)
        //.enableTracking() //disable when contour is enable https://developers.google.com/ml-kit/vision/face-detection/android
        .build()

    private val detector = FaceDetection.getClient(options)

    init {
        //add the detector in lifecycle observer to properly close it when it's no longer needed.
        lifecycle.addObserver(detector)
    }

    override fun analyze(imageProxy: ImageProxy) {
        overlay.setPreviewSize(Size(imageProxy.width,imageProxy.height))
        detectFaces(imageProxy)
    }

    private val successListener = OnSuccessListener<List<Face>> { faces ->
        Log.d(TAG, "Number of face detected: " + faces.size)
        overlay.setFaces(faces)
    }
    private val failureListener = OnFailureListener { e ->
        Log.e(TAG, "Face analysis failure.", e)
    }

    @SuppressLint("UnsafeExperimentalUsageError")
    private fun detectFaces(imageProxy: ImageProxy) {
        val image = InputImage.fromMediaImage(imageProxy.image as Image, imageProxy.imageInfo.rotationDegrees)
        detector.process(image)
            .addOnSuccessListener(successListener)
            .addOnFailureListener(failureListener)
            .addOnCompleteListener{
                imageProxy.close()
            }
    }

    companion object {
        private const val TAG = "FaceAnalyzer"
    }

}