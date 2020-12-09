package com.meekcode.mvvm.parceltracker.model

import android.content.Context
import androidx.test.core.app.ApplicationProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.google.common.truth.Truth
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class ParcelTrackerDatabaseTest {

    private lateinit var db: ParcelTrackerDatabase
    private lateinit var context: Context

    @Before
    fun setUp() {
        context = ApplicationProvider.getApplicationContext()
        db = ParcelTrackerDatabase.getDatabase(context)
        db.runInTransaction(Runnable {  }) //Need to begin a transaction to open db
    }

    @Test
    fun checkIfDatabaseExist()
    {
        Truth.assertThat(context.getDatabasePath(ParcelTrackerDatabase.DB_NAME).exists()).isTrue()
    }

    @Test
    fun checkIfDatabaseIsOpen()
    {
        Truth.assertThat(db.isOpen).isTrue()
    }

    @Test
    fun closeDatabaseAndCheck()
    {
        db.close()
        Truth.assertThat(!db.isOpen).isTrue()
    }

}