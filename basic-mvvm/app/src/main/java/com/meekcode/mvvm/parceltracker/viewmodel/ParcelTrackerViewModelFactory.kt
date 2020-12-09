package com.meekcode.mvvm.parceltracker.viewmodel

import android.content.Context
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.meekcode.mvvm.parceltracker.model.ParcelTrackerDatabase
import com.meekcode.mvvm.parceltracker.repository.ParcelTrackerRepository

class ParcelTrackerViewModelFactory(private val context: Context) : ViewModelProvider.Factory {

    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(ParcelTrackerViewModel::class.java)) {
            val repository = ParcelTrackerRepository.getInstance(ParcelTrackerDatabase.getDatabase(context).parcelDao())
            return ParcelTrackerViewModel(repository) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}