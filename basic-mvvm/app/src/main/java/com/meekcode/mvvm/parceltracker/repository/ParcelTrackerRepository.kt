package com.meekcode.mvvm.parceltracker.repository

import androidx.lifecycle.LiveData
import com.meekcode.mvvm.parceltracker.model.ParcelDao
import com.meekcode.mvvm.parceltracker.model.ParcelEntity

//Pass in the DAO instead of the whole database, because you only need access to the DAO
//Normally we use custom annotate @OpenForTesting see https://kotlinlang.org/docs/reference/compiler-plugins.html
open class ParcelTrackerRepository private constructor(private val parcelDao: ParcelDao) {

    companion object{
        @Volatile
        private var instance: ParcelTrackerRepository? = null

        fun getInstance(parcelDao: ParcelDao) : ParcelTrackerRepository
        {
            return instance ?: synchronized(this){
                instance ?: ParcelTrackerRepository(parcelDao).also { instance = it }
            }
        }
    }

    open fun getParcelStatusByTrackingNum(tracking_num: Int): LiveData<List<ParcelEntity>> {
        return parcelDao.getParcelStatusByTrackingNum(tracking_num)
    }
}