package com.meekcode.mvvm.parceltracker.model

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Query

@Dao
interface ParcelDao {

    @Query("SELECT * FROM Parcel WHERE tracking_num = :tracking_num ORDER BY date_time")
    fun getParcelStatusByTrackingNum(tracking_num: Int): LiveData<List<ParcelEntity>> //Use LiveData to run the query asynchronously and get results via observer pattern

}