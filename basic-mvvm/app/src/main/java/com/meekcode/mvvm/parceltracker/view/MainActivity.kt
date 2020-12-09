package com.meekcode.mvvm.parceltracker.view

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.meekcode.mvvm.parceltracker.R
import com.meekcode.mvvm.parceltracker.viewmodel.ParcelTrackerViewModel
import com.meekcode.mvvm.parceltracker.viewmodel.ParcelTrackerViewModelFactory
import java.text.SimpleDateFormat
import java.util.*

class MainActivity : AppCompatActivity() {

    lateinit var viewModel: ParcelTrackerViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        //initialize viewModel
        val factory = ParcelTrackerViewModelFactory(this)
        viewModel = ViewModelProvider(this,factory).get(ParcelTrackerViewModel::class.java)

        //initialize ui reference
        val etxtTrackNum = findViewById<EditText>(R.id.etxtTrackingNum)
        val txtResult = findViewById<TextView>(R.id.txtResult)
        val btnTrack = findViewById<Button>(R.id.btnTrack)

        btnTrack.setOnClickListener(View.OnClickListener {
            val trackNum = etxtTrackNum.text.toString()
            if (trackNum != "") {
                viewModel.setTrackingNum(trackNum.toInt())
                viewModel.getParcelStatus()
                    .observe(this, Observer { results ->

                        val stringBuilder = StringBuilder()
                        results.forEach {parcelEntity ->
                            stringBuilder.append(parcelEntity.status)
                            stringBuilder.appendLine()

                            //Normally we use a TypeConverter class for such datetime fields
                            val sdf = SimpleDateFormat("yyyy-MM-dd HH:mm")
                            sdf.timeZone = TimeZone.getTimeZone("GMT")
                            val netDate = Date(parcelEntity.date_time.toLong() * 1000)
                            val date  = sdf.format(netDate)

                            stringBuilder.append(date.toString())
                            stringBuilder.appendLine()
                            stringBuilder.append(parcelEntity.location)
                            stringBuilder.appendLine()
                            stringBuilder.append("=".repeat(20))
                            stringBuilder.appendLine()
                        }
                        //bind result to ui
                        txtResult.text = stringBuilder.toString()
                    })
            }
        })
    }

}