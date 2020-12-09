package com.meekcode.mvvm.parceltracker.viewmodel

import androidx.arch.core.executor.testing.InstantTaskExecutorRule
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Observer
import com.google.common.truth.Truth
import com.meekcode.mvvm.parceltracker.model.ParcelEntity
import com.meekcode.mvvm.parceltracker.repository.ParcelTrackerRepository
import org.junit.Before

import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.junit.MockitoJUnitRunner

@RunWith(MockitoJUnitRunner::class)
class ParcelTrackerViewModelTest {

    //We need this to test our LiveData observers
    @Rule
    @JvmField
    val rule = InstantTaskExecutorRule()

    private lateinit var viewModel: ParcelTrackerViewModel

    @Mock
    lateinit var repo: ParcelTrackerRepository

    @Mock
    lateinit var observer: Observer<List<ParcelEntity>>

    @Before
    fun setUp() {
        viewModel = ParcelTrackerViewModel(repo)
        viewModel.getParcelStatus().observeForever(observer)
    }

    @Test
    fun `test if track num is not a negative value`() {
        viewModel.setTrackingNum(1)
        Truth.assertThat(viewModel.trackingNumber.value).isGreaterThan(0)
    }

    @Test
    fun `verify if we got result from a correct track num`() {
        val expectedNum = 4321
        val trackNum = 4321

        val fakeResult = listOf(
            ParcelEntity(3, 3333, "pick-up", 3, "Philippines")
        )
        val fakeResponse = MutableLiveData<List<ParcelEntity>>()
        fakeResponse.value = fakeResult

        Mockito.`when`(repo.getParcelStatusByTrackingNum(expectedNum)).then {
            fakeResponse
        }

        viewModel.setTrackingNum(trackNum)
        Mockito.verify(observer).onChanged(fakeResult)
    }
}