package com.meekcode.mvvm.parceltracker.model

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import org.jetbrains.annotations.NotNull

@Entity(tableName = "Parcel")
data class ParcelEntity(
    @PrimaryKey(autoGenerate = true) @ColumnInfo(name = "event_id") @NotNull val event_id: Int,
    @ColumnInfo(name = "tracking_num") @NotNull val tracking_num: Int,
    @ColumnInfo(name = "status") val status: String?,
    @ColumnInfo(name = "date_time") val date_time: Int,
    @ColumnInfo(name = "location") val location: String?,
)