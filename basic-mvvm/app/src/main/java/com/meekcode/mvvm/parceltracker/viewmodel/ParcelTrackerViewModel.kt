package com.meekcode.mvvm.parceltracker.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Transformations
import androidx.lifecycle.ViewModel
import com.meekcode.mvvm.parceltracker.model.ParcelEntity
import com.meekcode.mvvm.parceltracker.repository.ParcelTrackerRepository

//Normally we use custom annotate @OpenForTesting see https://kotlinlang.org/docs/reference/compiler-plugins.html
open class ParcelTrackerViewModel(private val parcelTrackerRepository: ParcelTrackerRepository): ViewModel()
{
    var trackingNumber = MutableLiveData<Int>()

    open fun getParcelStatus(): LiveData<List<ParcelEntity>> {
        return Transformations.switchMap(trackingNumber){
                trackNoInput ->
            parcelTrackerRepository.getParcelStatusByTrackingNum(trackNoInput)
        }
    }

    fun setTrackingNum(trackingNo_input: Int)
    {
        trackingNumber.value = trackingNo_input
    }
}