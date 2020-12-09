package com.meekcode.mvvm.parceltracker.model

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

@Database(entities = [ParcelEntity::class], version = 1, exportSchema = false)
abstract class ParcelTrackerDatabase  : RoomDatabase() {
    abstract fun parcelDao(): ParcelDao

    companion object{
        // Singleton prevents multiple instances of database opening at the
        // same time as each RoomDatabase instance is fairly expensive,
        // and you rarely need access to multiple instances within a single process

        @Volatile
        private var instance: ParcelTrackerDatabase? = null

        const val DB_NAME = "CopiedParcelTracker.db"
        fun getDatabase(context: Context): ParcelTrackerDatabase
        {
            return instance ?: synchronized(this)
            {
                val dbInstance =  Room.databaseBuilder(context.applicationContext, ParcelTrackerDatabase::class.java , DB_NAME)
                    .createFromAsset("database/InitialParcelTracker.db")
                    //.addMigrations(MIGRATION) // do migration if you want to get the updated prepopulated database
                    .build()
                instance = dbInstance
                dbInstance
            }
        }

    }
}