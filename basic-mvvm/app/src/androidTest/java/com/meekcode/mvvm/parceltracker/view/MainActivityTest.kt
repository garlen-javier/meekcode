package com.meekcode.mvvm.parceltracker.view

import androidx.test.espresso.Espresso.onView
import androidx.test.espresso.action.ViewActions
import androidx.test.espresso.action.ViewActions.*
import androidx.test.espresso.assertion.ViewAssertions
import androidx.test.espresso.matcher.ViewMatchers
import androidx.test.espresso.matcher.ViewMatchers.withId
import androidx.test.espresso.matcher.ViewMatchers.withText
import androidx.test.ext.junit.rules.ActivityScenarioRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.filters.LargeTest
import com.google.common.truth.Truth
import com.meekcode.mvvm.parceltracker.R
import com.meekcode.mvvm.parceltracker.viewmodel.ParcelTrackerViewModel
import org.hamcrest.CoreMatchers
import org.hamcrest.CoreMatchers.not
import org.junit.Before

import org.junit.Assert.*
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
@LargeTest
class MainActivityTest {

    @get:Rule
    var activityRule: ActivityScenarioRule<MainActivity>
            = ActivityScenarioRule(MainActivity::class.java)

    private lateinit var viewModel: ParcelTrackerViewModel

    @Before
    fun setUp() {
        activityRule.scenario.onActivity { activity ->
            viewModel = activity.viewModel
        }
    }

    @Test
    fun textResultIsNotEmptyIfCorrectInput()
    {
        onView(withId(R.id.etxtTrackingNum))
            .perform(typeText("3333"), closeSoftKeyboard())
        onView(withId(R.id.btnTrack)).perform(click())

        onView(withId(R.id.txtResult))
            .check(ViewAssertions.matches(not(withText(""))))
    }

    @Test
    fun textResultIsEmptyIfWrongInput()
    {
        onView(withId(R.id.etxtTrackingNum)).perform(clearText())
        onView(withId(R.id.btnTrack)).perform(click())

        onView(withId(R.id.txtResult))
            .check(ViewAssertions.matches((withText(""))))
    }

    @Test
    fun viewModelTackNumAcceptsIntegerInput()
    {
        val input = "1234"
        onView(withId(R.id.etxtTrackingNum))
            .perform(typeText(input), closeSoftKeyboard())
        onView(withId(R.id.btnTrack)).perform(click())

        Truth.assertThat(viewModel.trackingNumber.value).isNotNull()
        Truth.assertThat(viewModel.trackingNumber.value).isEqualTo(input.toInt())
    }

}