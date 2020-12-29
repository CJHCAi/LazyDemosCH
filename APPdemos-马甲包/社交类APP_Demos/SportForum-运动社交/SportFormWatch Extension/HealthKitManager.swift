//
//  HealthKitManager.swift
//  iWalk
//
//  Created by Andrea Piscitello on 14/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitManager {
    static let instance = HealthKitManager()
    let healthKitStore:HKHealthStore = HKHealthStore()
    
    var realTimeQueries = [HKQuery]()
    
    
    private init() {
    }
    
    // MARK: HealthKit Configuration
    func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
    {
        // 1. Set the types you want to read from HK Store
        let healthKitTypesToRead = Set(arrayLiteral:
            //HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
            //HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType)!,
            //HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!,
            //HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!,
            //HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!,
            //HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!,
            
            //HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
            HKObjectType.workoutType()
        )
        
        // 2. Set the types you want to write to HK Store
        let healthKitTypesToWrite = Set(arrayLiteral:
            //HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)!,
            //HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
            HKQuantityType.workoutType(),
            //HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!,
            //HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!,
            //HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
        )
        
        // 3. If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable()
        {
            let error = NSError(domain: "com.ice139.yuedongli.watchapp", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if( completion != nil )
            {
                completion(success:false, error:error)
            }
            return;
        }
        
        // 4.  Request HealthKit authorization
        healthKitStore.requestAuthorizationToShareTypes(healthKitTypesToWrite, readTypes: healthKitTypesToRead, completion: { (success, error) -> Void in
            
            if( completion != nil )
            {
                completion(success:success,error:error)
            }
        })
    }
//    
//    func authorizeHealthKit() {
//        authorizeHealthKit { (authorized,  error) -> Void in
//            if authorized {
//                print("HealthKit authorization received.")
//            }
//            else
//            {
//                print("HealthKit authorization denied!")
//                if error != nil {
//                    print("\(error)")
//                }
//            }
//        }
//    }
    
    // MARK: Fetch Data
    func getUserInfo() -> (birthday: NSDate?, gender: String?){
        
        let birthday = birthDay()
        let gender = biologicalSex()
        
        return (birthday, gender)
    }
    
    func birthDay() -> NSDate? {
        let birthDay: NSDate?
        
        do {
            try birthDay = healthKitStore.dateOfBirth()
            return birthDay
            
        } catch {
            print("Error reading Birthday")
            return nil
        }
        
    }
    
    func biologicalSex() -> String? {
        let sex :HKBiologicalSexObject
        
        do {
            sex = try healthKitStore.biologicalSex()
            switch sex.biologicalSex {
            case .Female:
                return "Female"
            case .Male:
                return "Male"
            case .NotSet:
                return nil
            default:
                return nil
            }
        }
        catch {
            print("Error handling Biological Sex")
        }
        return nil
    }
    
    
    
    func readMostRecentSample(sampleType:HKSampleType , completion: ((HKSample!, NSError!) -> Void)!)
    {
        
        // 1. Build the Predicate
        let past = NSDate.distantPast()
        let now   = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
        let limit = 1
        
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
            { (sampleQuery, results, error ) -> Void in
                
                if let queryError = error {
                    completion(nil,queryError)
                    return;
                }
                
                // Get the first sample
                let mostRecentSample = results!.first as? HKQuantitySample
                
                // Execute the completion closure
                if completion != nil {
                    completion(mostRecentSample,nil)
                }
        }
        // 5. Execute the Query
        self.healthKitStore.executeQuery(sampleQuery)
    }
    
    func fetchWeight() {
        // 1. Construct an HKSampleType for weight
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        
        // 2. Call the method to read the most recent weight sample
        self.readMostRecentSample(sampleType!, completion: { (mostRecentWeight, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading weight from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
            // 3. Format the weight to display it on the screen
            //let weight = mostRecentWeight as? HKQuantitySample;
            
            //let timestamp = weight?.endDate
            
            //let weightInfo = UpdatableInformation(value: weight, latestUpdate: timestamp)
            
            //UserInfo.instance.updateWeight(weightInfo)
            
        })
    }
    
    func fetchHeight() {
        
        // 1. Construct an HKSampleType for Height
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        
        // 2. Call the method to read the most recent Height sample
        self.readMostRecentSample(sampleType!, completion: { (mostRecentHeight, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading height from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
            
//            let height = mostRecentHeight as? HKQuantitySample;
//            
//            // 3. Format the height to display it on the screen
//            let timestamp = height?.endDate
//            
//            let heightInfo = UpdatableInformation(value: height, latestUpdate: timestamp)
//            
//            UserInfo.instance.updateHeight(heightInfo)
            
            
        })
    }
    
    // MARK: Save Data
    func saveBMISample(bmi:Double, date:NSDate ) {
        
        // 1. Create a BMI Sample
        
        let bmiSample = bmiSampleFromDouble(bmi, date: date)
        // 2. Save the sample in the store
        healthKitStore.saveObject(bmiSample, withCompletion: { (success, error) -> Void in
            if( error != nil ) {
                print("Error saving BMI sample: \(error!.localizedDescription)")
            } else {
                print("BMI sample saved successfully!")
            }
        })
    }
    
    
    func saveHeightSample(height:Double, date:NSDate ) {
        
        // 1. Create a BMI Sample
        let heightSample = heightSampleFromDouble(height, date: date)
        
        // 2. Save the sample in the store
        healthKitStore.saveObject(heightSample, withCompletion: { (success, error) -> Void in
            if( error != nil ) {
                print("Error saving Height sample: \(error!.localizedDescription)")
            } else {
                print("Height sample saved successfully!")
            }
        })
    }
    
    func saveWeightSample(weight:Double, date:NSDate ) {
        
        // 1. Create a BMI Sample
        let weightSample = weightSampleFromDouble(weight, date: date)
        
        // 2. Save the sample in the store
        healthKitStore.saveObject(weightSample, withCompletion: { (success, error) -> Void in
            if( error != nil ) {
                print("Error saving Weight sample: \(error!.localizedDescription)")
            } else {
                print("Weight sample saved successfully!")
            }
        })
    }
    
    
    func heightSampleFromDouble(height: Double, date: NSDate) -> HKQuantitySample {
        let heightType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        let heightQuantity = HKQuantity(unit: HKUnit(fromString: "cm"), doubleValue: height)
        let heightSample = HKQuantitySample(type: heightType!, quantity: heightQuantity, startDate: date, endDate: date)
        return heightSample
    }
    
    func heightDoubleFromSample(height: HKQuantitySample) -> Double {
        return height.quantity.doubleValueForUnit(HKUnit(fromString: "cm"))
    }
    
    
    func weightSampleFromDouble(weight: Double, date: NSDate) -> HKQuantitySample {
        let weightType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        let weightQuantity = HKQuantity(unit: HKUnit(fromString: "kg"), doubleValue: weight)
        let weightSample = HKQuantitySample(type: weightType!, quantity: weightQuantity, startDate: date, endDate: date)
        
        return weightSample
    }
    
    func bmiSampleFromDouble(bmi: Double, date: NSDate) -> HKQuantitySample {
        let bmiType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)
        let bmiQuantity = HKQuantity(unit: HKUnit.countUnit(), doubleValue: bmi)
        return HKQuantitySample(type: bmiType!, quantity: bmiQuantity, startDate: date, endDate: date)
    }
    
    func weightDoubleFromSample(weight: HKQuantitySample) -> Double {
        return weight.quantity.doubleValueForUnit(HKUnit(fromString: "kg"))
    }
    
    
    // MARK: Statistic Queries
    func mostStepsInADay() {
        let calendar = NSCalendar.currentCalendar()
        
        let interval = NSDateComponents()
        interval.day = 1
        
        let anchorComponents = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
        anchorComponents.hour = 0
        
        let anchorDate = calendar.dateFromComponents(anchorComponents)
        
        let quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        // Create the query
        let query = HKStatisticsCollectionQuery(quantityType: quantityType!,
            quantitySamplePredicate: nil,
            options: .CumulativeSum,
            anchorDate: anchorDate!,
            intervalComponents: interval)
        
        // Set the results handler
        query.initialResultsHandler = {
            query, results, error in
            
            if error != nil {
                // Perform proper error handling here
                print("*** An error occurred while calculating the statistics: \(error!.localizedDescription) ***")
                //abort()
                return
            }
            
            let statistics = results?.statistics()
            var maxValue = 0.0
            var maxDate : NSDate?
            
            for s in statistics! {
                if let quantity = s.sumQuantity() {
                    let date = s.startDate
                    let value = quantity.doubleValueForUnit(HKUnit.countUnit())
                    
                    if(value >= maxValue) {
                        maxValue = value
                        maxDate = date
                    }
                    
                }
            }
            
            if maxValue > 0.0 {
                //                print("value: \(maxValue), date: \(maxDate)")
                
                // Save data into the model
//                RecordsModel.instance.mostStepsInADay.value = Int(maxValue)
//                RecordsModel.instance.mostStepsInADay.day = maxDate
//                
//                NSNotificationCenter.defaultCenter().postNotificationName(Notifications.mostStepsInADay.dayAndValueUpdated, object: nil)
                self.stepsByHour(maxDate!)
            }
            
        }
        
        healthKitStore.executeQuery(query)
    }
    
    func stepsByHour(date: NSDate) {
        let calendar = NSCalendar.currentCalendar()
        
        let interval = NSDateComponents()
        interval.hour = 1
        
        let anchorComponents = calendar.components([.Hour, .Day, .Month, .Year], fromDate: NSDate())
        anchorComponents.minute = 0
        
        let anchorDate = calendar.dateFromComponents(anchorComponents)
        
        let quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        // Create the query
        let query = HKStatisticsCollectionQuery(quantityType: quantityType!,
            quantitySamplePredicate: nil,
            options: .CumulativeSum,
            anchorDate: anchorDate!,
            intervalComponents: interval)
        
        // Set the results handler
        query.initialResultsHandler = {
            query, results, error in
            
            if error != nil {
                // Perform proper error handling here
                print("*** An error occurred while calculating the statistics: \(error!.localizedDescription) ***")
            }
            
            let nowComp = calendar.components([.Day, .Month, .Year], fromDate: date)
            
            let midnightComp = NSDateComponents()
            midnightComp.day = nowComp.day
            midnightComp.month = nowComp.month
            midnightComp.year = nowComp.year
            
            let midnightDay = calendar.dateFromComponents(midnightComp)
            midnightComp.day += 1
            let nextMidnight = calendar.dateFromComponents(midnightComp)

            
            var steps = [Int](count:24, repeatedValue: 0)
            
            let hourFormatter = NSDateFormatter()
            hourFormatter.dateFormat = "HH"
            
            results!.enumerateStatisticsFromDate(midnightDay!, toDate: nextMidnight!) {
                statistics, stop in
                
                if let quantity = statistics.sumQuantity() {
                    let date = hourFormatter.stringFromDate(statistics.startDate)
                    let value = Int(round(quantity.doubleValueForUnit(HKUnit.countUnit())))
                    
                    //                    print("\(date)  \(value)")
                    
                    let index = Int(date)
                    
                    steps[index!] = value
                }
            }
            
            //RecordsModel.instance.mostStepsInADay.steps = steps
            
            //NSNotificationCenter.defaultCenter().postNotificationName(Notifications.mostStepsInADay.hoursUpdated, object: nil)
        }
        healthKitStore.executeQuery(query)
        
    }
    
    func averageDailySteps() {
        let calendar = NSCalendar.currentCalendar()
        
        let interval = NSDateComponents()
        interval.day = 1
        
        let anchorComponents = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
        anchorComponents.hour = 0
        
        let anchorDate = calendar.dateFromComponents(anchorComponents)
        
        let quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        // Create the query
        let query = HKStatisticsCollectionQuery(quantityType: quantityType!,
            quantitySamplePredicate: nil,
            options: .CumulativeSum,
            anchorDate: anchorDate!,
            intervalComponents: interval)
        
        // Set the results handler
        query.initialResultsHandler = {
            query, results, error in
            
            if error != nil {
                // Perform proper error handling here
                print("*** An error occurred while calculating the statistics: \(error!.localizedDescription) ***")
                //abort()
                return
            }
            
            let statistics = results?.statistics()
            let totalDay = Double((statistics?.count)!)
            var totalSteps = 0.0
            
            
            let endDate = NSDate()
            let date = endDate.dateByAddingTimeInterval(-365*60*60*24)
            
            
            results!.enumerateStatisticsFromDate(date, toDate: endDate) {
                statistics, stop in
                if let quantity = statistics.sumQuantity() {
                    let value = quantity.doubleValueForUnit(HKUnit.countUnit())
                    totalSteps = totalSteps + value
                }
            }
            
            let averageSteps = totalSteps/totalDay
            
            if averageSteps > 0{
                //                print("value: \(averageSteps)")
                
                // Save data into the model
                //RecordsModel.instance.averageDailySteps.value = Int(round(averageSteps))
                
                //NSNotificationCenter.defaultCenter().postNotificationName(Notifications.averageDailySteps.valueUpdated, object: nil)
                
            }
        }
        
        healthKitStore.executeQuery(query)
        
    }
    
    func averageStepsByHour() {
        let calendar = NSCalendar.currentCalendar()
        
        let interval = NSDateComponents()
        interval.hour = 1
        
        let anchorComponents = calendar.components([.Hour], fromDate: NSDate())
        anchorComponents.minute = 0
        
        let anchorDate = calendar.dateFromComponents(anchorComponents)
        
        let quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        // Create the query
        let query = HKStatisticsCollectionQuery(quantityType: quantityType!,
            quantitySamplePredicate: nil,
            options: .CumulativeSum,
            anchorDate: anchorDate!,
            intervalComponents: interval)
        
        // Set the results handler
        query.initialResultsHandler = {
            query, results, error in
            
            if error != nil {
                // Perform proper error handling here
                print("*** An error occurred while calculating the statistics: \(error!.localizedDescription) ***")
                return
            }
            
            
            //           let endDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: date, options: nil)
            let endDate = NSDate()
            let date = endDate.dateByAddingTimeInterval(-365*60*60*24)
            
            var steps = [Int](count:24, repeatedValue: 0)
            
            let hourFormatter = NSDateFormatter()
            hourFormatter.dateFormat = "HH"
            
            results!.enumerateStatisticsFromDate(date, toDate: endDate) {
                statistics, stop in
                
                if let quantity = statistics.sumQuantity() {
                    let date = hourFormatter.stringFromDate(statistics.startDate)
                    let value = Int(round(quantity.doubleValueForUnit(HKUnit.countUnit())))
                    
                    let index = Int(date)
                    
                    steps[index!] += value
                }
            }
            
            // Compute the year average
            for i in 0..<steps.count {
                steps[i] /= 365
            }
            
            //RecordsModel.instance.averageDailySteps.steps = steps
            
            //NSNotificationCenter.defaultCenter().postNotificationName(Notifications.averageDailySteps.hoursUpdated, object: nil)
        }
        healthKitStore.executeQuery(query)
        
    }
    
    
    func totalLifetime(attribute : Int) {
//        let calendar = NSCalendar.currentCalendar()
//        
//        let interval = NSDateComponents()
//        interval.day = 1
//        
//        // Set the anchor date to Monday at 3:00 a.m.
//        let anchorComponents = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
//        anchorComponents.hour = 0
//        
//        let anchorDate = calendar.dateFromComponents(anchorComponents)
//        var quantityType : HKQuantityType?
//        
//        switch attribute {
//        case RecordsModel.TotalRecordsAttributes.Steps.rawValue:
//            quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!
//        case RecordsModel.TotalRecordsAttributes.Calories.rawValue:
//            quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!
//        case RecordsModel.TotalRecordsAttributes.Distance.rawValue:
//            quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!
//        default:
//            quantityType = nil
//        }
//        
//        // Create the query
//        let query = HKStatisticsCollectionQuery(quantityType: quantityType!,
//            quantitySamplePredicate: nil,
//            options: .CumulativeSum,
//            anchorDate: anchorDate!,
//            intervalComponents: interval)
//        
//        // Set the results handler
//        query.initialResultsHandler = {
//            query, results, error in
//            
//            if error != nil {
//                // Perform proper error handling here
//                print("*** An error occurred while calculating the statistics: \(error!.localizedDescription) ***")
////                abort()
//                return
//            }
//            
//            let statistics = results?.statistics()
//            var totalLifetimeValue = 0.0
//            
//            for s in statistics! {
//                if let quantity = s.sumQuantity() {
//                    
//                    var value : Double?
//                    
//                    switch attribute {
//                    case RecordsModel.TotalRecordsAttributes.Steps.rawValue:
//                        value = quantity.doubleValueForUnit(HKUnit.countUnit())
//                        
//                    case RecordsModel.TotalRecordsAttributes.Calories.rawValue:
//                        value = quantity.doubleValueForUnit(HKUnit.calorieUnit())/1000
//                        
//                    case RecordsModel.TotalRecordsAttributes.Distance.rawValue:
//                        value = quantity.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(.Kilo))
//                    default:
//                        value = nil
//                    }
//                    
//                    totalLifetimeValue += value!
//                }
//            }
//            
//            if totalLifetimeValue > 0{
//                let total = Int(totalLifetimeValue)
//                
//                switch attribute {
//                case RecordsModel.TotalRecordsAttributes.Steps.rawValue:
//                    RecordsModel.instance.totalLifetimeRecords.steps = total
//                    NSNotificationCenter.defaultCenter().postNotificationName(Notifications.totalRecords.stepsUpdated, object: nil)
//                    
//                case RecordsModel.TotalRecordsAttributes.Calories.rawValue:
//                    RecordsModel.instance.totalLifetimeRecords.calories = total
//                    NSNotificationCenter.defaultCenter().postNotificationName(Notifications.totalRecords.caloriesUpdated, object: nil)
//                    
//                case RecordsModel.TotalRecordsAttributes.Distance.rawValue:
//                    RecordsModel.instance.totalLifetimeRecords.distance = total
//                    NSNotificationCenter.defaultCenter().postNotificationName(Notifications.totalRecords.distanceUpdated, object: nil)
//                default:
//                    break;
//                }
//                
//                
//                
//            }
//        }
//        
//        healthKitStore.executeQuery(query)
    }
    
    
    func periodicAttributeQuery(period: Int, attribute: Int) {
//        let calendar = NSCalendar.currentCalendar()
//        
//        let interval = NSDateComponents()
//        var anchorComponents = NSDateComponents()
//        
//        switch period {
//        case StatsModel.Period.Week.rawValue:
//            interval.day = 1
//            anchorComponents = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
//            anchorComponents.hour = 0
//        case StatsModel.Period.Month.rawValue:
//            interval.day = 1
//            anchorComponents = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
//            anchorComponents.hour = 0
//        case StatsModel.Period.Year.rawValue:
//            interval.month = 1
//            anchorComponents = calendar.components([.Month, .Year], fromDate: NSDate())
//            anchorComponents.day = 1
//        default: break
//        }
//        
//        let anchorDate = calendar.dateFromComponents(anchorComponents)
//        var quantityType : HKQuantityType?
//        
//        switch attribute {
//        case RecordsModel.TotalRecordsAttributes.Steps.rawValue:
//            quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!
//        case RecordsModel.TotalRecordsAttributes.Calories.rawValue:
//            quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!
//        case RecordsModel.TotalRecordsAttributes.Distance.rawValue:
//            quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!
//        default:
//            quantityType = nil
//        }
//        
//        // Create the query
//        let query = HKStatisticsCollectionQuery(quantityType: quantityType!,
//            quantitySamplePredicate: nil,
//            options: .CumulativeSum,
//            anchorDate: anchorDate!,
//            intervalComponents: interval)
//        
//        // Set the results handler
//        query.initialResultsHandler = {
//            query, results, error in
//            
//            if error != nil {
//                // Perform proper error handling here
//                print("*** An error occurred while calculating the statistics: \(error!.localizedDescription) ***")
////                abort()
//            }
//   
//            var offset = 0.0
//            let hourFormatter = NSDateFormatter()
//            var length = 0
//            
//            switch period {
//            case StatsModel.Period.Week.rawValue:
//                offset = 6
//                hourFormatter.dateFormat = "EEE"
//                length = 7
//                
//            case StatsModel.Period.Month.rawValue:
//                offset = 30
//                hourFormatter.dateFormat = "dd MMM"
//                length = 31
//                
//            case StatsModel.Period.Year.rawValue:
//                offset = 360
//                hourFormatter.dateFormat = "MMM"
//                length = 13
//                
//            default:
//                break
//            }
//            
//            let endDate = NSDate()
//            let startDate = endDate.dateByAddingTimeInterval(-offset*60*60*24)
//            
//            var values = [Double](count: length, repeatedValue : 0)
//            var labels = [String](count: length, repeatedValue : "")
//            
//            
//            var index = 0
//            
//            results!.enumerateStatisticsFromDate(startDate, toDate: endDate) {
//                statistics, stop in
//                
//                if let quantity = statistics.sumQuantity() {
//                    let date = hourFormatter.stringFromDate(statistics.startDate)
//                    
//                    var value  = 0.0
//                    
//                    switch attribute {
//                        
//                    case RecordsModel.TotalRecordsAttributes.Steps.rawValue:
//                        value = quantity.doubleValueForUnit(HKUnit.countUnit())
//                        
//                    case RecordsModel.TotalRecordsAttributes.Calories.rawValue:
//                        value = quantity.doubleValueForUnit(HKUnit.calorieUnit())/1000
//                        
//                    case RecordsModel.TotalRecordsAttributes.Distance.rawValue:
//                        value = quantity.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(.Kilo))
//                    default:
//                        break
//                    }
//                    
//                    values[index] = value
//                    labels[index] = date
//                    
//                    index++
//                }
//            }
//            
//            
//            if values.count > 0{
//                
//                switch attribute {
//                case RecordsModel.TotalRecordsAttributes.Steps.rawValue:
//                    StatsModel.instance.stepsData.steps[period] = values
//                    StatsModel.instance.stepsData.labels[period] = labels
//                    
//                    NSNotificationCenter.defaultCenter().postNotificationName(Notifications.stats.stepsUpdated, object: nil)
//                    
//                case RecordsModel.TotalRecordsAttributes.Calories.rawValue:
//                    StatsModel.instance.caloriesData.calories[period] = values
//                    StatsModel.instance.caloriesData.labels[period] = labels
//                    
//                    NSNotificationCenter.defaultCenter().postNotificationName(Notifications.stats.caloriesUpdated, object: nil)
//                    
//                case RecordsModel.TotalRecordsAttributes.Distance.rawValue:
//                    StatsModel.instance.distanceData.distance[period] = values
//                    StatsModel.instance.distanceData.labels[period] = labels
//                    
//                    NSNotificationCenter.defaultCenter().postNotificationName(Notifications.stats.distanceUpdated, object: nil)
//                default:
//                    break;
//                }
//                
//                
//                
//            }
//        }
//        
//        healthKitStore.executeQuery(query)
    }
    
    
    func plotWeight() {
        self.fetchWeightHistory({ (samples, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading weight from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
            var results = [Double]()
            var labels = [NSDate]()
            
            if let weightSamples = samples {
                
                for weight in weightSamples {
                    let value = weight.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo))
                    let date = weight.startDate
                    results.append(value)
                    labels.append(date)
                }
                //UserInfo.instance.weightHistoryDates = labels
                //UserInfo.instance.weightHistoryValues = results
                
                //NSNotificationCenter.defaultCenter().postNotificationName(Notifications.weightHistoryUpdated, object: nil)
            }
        })

    }

    func fetchWeightHistory(completion: (([HKQuantitySample!]?, NSError!) -> Void)!) {
        
        let past = NSDate.distantPast()
        let now   = NSDate()
        
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: true)
        let limit = 10
        let sampleType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType!, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
            { (sampleQuery, results, error ) -> Void in
                
                if let queryError = error {
                    completion(nil, queryError)
                    return;
                }
                
                // Get the first sample
                let mostRecentSamples = results as! [HKQuantitySample]?
                
                // Execute the completion closure
                if completion != nil {
                    completion(mostRecentSamples,nil)
                }
        }
        // 5. Execute the Query
        self.healthKitStore.executeQuery(sampleQuery)
    }
    
    
    // MARK: RealTime Queries
    
    func currentSteps() {
        //fetchCurrentValue(TodayModel.Attribute.Steps)
    }
    
    func currentCalories() {
        //fetchCurrentValue(TodayModel.Attribute.Calories)
    }
    
    func currentDistance() {
        //fetchCurrentValue(TodayModel.Attribute.Distance)
    }
    
    func currentTime() {
        let calendar = NSCalendar.currentCalendar()
        
        let now = NSDate()
        let nowComp = calendar.components([.Day, .Month, .Year], fromDate: now)
        
        let midnightComp = NSDateComponents()
        midnightComp.day = nowComp.day
        midnightComp.month = nowComp.month
        midnightComp.year = nowComp.year
        
        let midnightDay = calendar.dateFromComponents(midnightComp)
        
        let onlyTodayPredicate = HKQuery.predicateForSamplesWithStartDate(midnightDay, endDate: nil, options: .None)
        
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: true)
        
        let sampleType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType!, predicate: onlyTodayPredicate, limit: 1000000, sortDescriptors: [sortDescriptor])
            { (sampleQuery, results, error ) -> Void in
                
                if let _ = error {
//                    abort()
                    return
                    
                }
                
                var timeCount = 0.0
                for s in results! {
                    timeCount += Double(s.endDate.timeIntervalSinceDate(s.startDate))
                }
                //TodayModel.instance.timeCount = timeCount
                //NSNotificationCenter.defaultCenter().postNotificationName(Notifications.today.timeUpdated, object: nil)
                
                

        }
        
        realTimeQueries.append(sampleQuery)
        
        // 5. Execute the Query
        self.healthKitStore.executeQuery(sampleQuery)
    }
    
//    func fetchCurrentValue(attribute: TodayModel.Attribute) {
//        let calendar = NSCalendar.currentCalendar()
//        
//        let interval = NSDateComponents()
//        interval.day = 1
//        
//        let anchorComponents = calendar.components([.Hour, .Month, .Year], fromDate: NSDate())
//        anchorComponents.hour = 0
//        
//        let anchorDate = calendar.dateFromComponents(anchorComponents)
//        
//        var quantityType : HKQuantityType?
//        
//        switch attribute {
//        case TodayModel.Attribute.Steps:
//            quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
//        case TodayModel.Attribute.Calories:
//            quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
//        case TodayModel.Attribute.Distance:
//            quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
//        }
//        
//        
//        let now = NSDate()
//        let nowComp = calendar.components([.Day, .Month, .Year], fromDate: now)
//        
//        let midnightComp = NSDateComponents()
//        midnightComp.day = nowComp.day
//        midnightComp.month = nowComp.month
//        midnightComp.year = nowComp.year
//        
//        let midnightDay = calendar.dateFromComponents(midnightComp)
//        
//        let onlyTodayPredicate = HKQuery.predicateForSamplesWithStartDate(midnightDay, endDate: nil, options: .None)
//        
//        
//        // Create the query
//        let query = HKStatisticsCollectionQuery(quantityType: quantityType!,
//            quantitySamplePredicate: onlyTodayPredicate,
//            options: .CumulativeSum,
//            anchorDate: anchorDate!,
//            intervalComponents: interval)
//        
//        // Set the results handler
//        query.initialResultsHandler = {
//            query, results, error in
//            
//            self.todayHandler(results, error: error, attribute: attribute)
//        }
//        
//        // Set the update Handler
//        query.statisticsUpdateHandler = {
//            query, stats, results, error in
//            
//            self.todayHandler(results, error: error, attribute: attribute)
//        }
//        
//        realTimeQueries.append(query)
//        
//        healthKitStore.executeQuery(query)
//    }
//    
//    func todayHandler(results: HKStatisticsCollection?, error: NSError?, attribute: TodayModel.Attribute) {
//        if error != nil {
//            // Perform proper error handling here
//            print("*** An error occurred while calculating the statistics: \(error!.localizedDescription) ***")
////            abort()
//        }
//        
//        let stats = results?.statistics()
//        
//        if stats?.count > 0{
//            
//            switch attribute {
//            case TodayModel.Attribute.Steps:
//                let steps = Int(stats![0].sumQuantity()!.doubleValueForUnit(HKUnit.countUnit()))
//                TodayModel.instance.stepsCount = steps
//                NSNotificationCenter.defaultCenter().postNotificationName(Notifications.today.stepsUpdated, object: nil)
//                
//            case TodayModel.Attribute.Calories:
//                let calories = stats![0].sumQuantity()!.doubleValueForUnit(HKUnit.calorieUnit())/1000
//                TodayModel.instance.caloriesCount = calories
//                NSNotificationCenter.defaultCenter().postNotificationName(Notifications.today.caloriesUpdated, object: nil)
//                
//            case TodayModel.Attribute.Distance:
//                let distance = stats![0].sumQuantity()!.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(.Kilo))
//                TodayModel.instance.distanceCount = distance
//                NSNotificationCenter.defaultCenter().postNotificationName(Notifications.today.distanceUpdated, object: nil)
//            }
//        }
//
//    }
    
    func currentStepsDistribution() {
        let calendar = NSCalendar.currentCalendar()
        
        let interval = NSDateComponents()
        interval.hour = 1
        
        let anchorComponents = calendar.components([.Hour, .Day, .Month, .Year], fromDate: NSDate())
        anchorComponents.minute = 0
        
        let anchorDate = calendar.dateFromComponents(anchorComponents)
        
        let quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        // Create the query
        let query = HKStatisticsCollectionQuery(quantityType: quantityType!,
            quantitySamplePredicate: nil,
            options: .CumulativeSum,
            anchorDate: anchorDate!,
            intervalComponents: interval)
        
        // Set the results handler
        query.initialResultsHandler = {
            query, results, error in
            
            self.stepsDistributionHandler(results, error: error)
        }
        
        query.statisticsUpdateHandler = {
            query, stats, results, error in
            
            self.stepsDistributionHandler(results, error: error)
        }
        
        realTimeQueries.append(query)
        
        healthKitStore.executeQuery(query)
    }
    
    func stepsDistributionHandler(results: HKStatisticsCollection?, error: NSError?) {
        
        if error != nil {
            // Perform proper error handling here
            print("*** An error occurred while calculating the statistics: \(error!.localizedDescription) ***")
//            abort()
            return
        }
        let calendar = NSCalendar.currentCalendar()

        let nowComp = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
        
        let midnightComp = NSDateComponents()
        midnightComp.day = nowComp.day
        midnightComp.month = nowComp.month
        midnightComp.year = nowComp.year
        
        let midnightDay = calendar.dateFromComponents(midnightComp)
        midnightComp.day += 1
        let nextMidnight = calendar.dateFromComponents(midnightComp)
        
        
        
        var steps = [Double](count:24, repeatedValue: 0.0)
        
        let hourFormatter = NSDateFormatter()
        hourFormatter.dateFormat = "HH"
        
        results!.enumerateStatisticsFromDate(midnightDay!, toDate: nextMidnight!) {
            statistics, stop in
            
            if let quantity = statistics.sumQuantity() {
                let date = hourFormatter.stringFromDate(statistics.startDate)
                let value = round(quantity.doubleValueForUnit(HKUnit.countUnit()))
                
                let index = Int(date)
                
                steps[index!] = value
                
            }
        }
        
        //TodayModel.instance.values = steps
        
        
        //NSNotificationCenter.defaultCenter().postNotificationName(Notifications.today.stepsDistributionUpdated, object: nil)
    }
    
    func stopQueries() {
        for q in realTimeQueries {
            healthKitStore.stopQuery(q)
        }
        realTimeQueries.removeAll()
    }
    
    // MARK: Workout
    func saveSession(steps: Double, distance: Double, calories: Double, seconds: Double, startDate: NSDate) {
        let energyBurned = HKQuantity(unit: HKUnit.kilocalorieUnit(),
            doubleValue: calories)
        
        let distance = HKQuantity(unit: HKUnit.mileUnit(),
            doubleValue: distance)
        
        let endDate = NSDate()
        
        let minutes = seconds/60
        
        // Provide summary information when creating the workout.
        let walk = HKWorkout(activityType: HKWorkoutActivityType.Walking,
            startDate: startDate, endDate: endDate, duration: minutes,
            totalEnergyBurned: energyBurned, totalDistance: distance, metadata: nil)
        
        // Save the workout before adding detailed samples.
        healthKitStore.saveObject(walk) { (success, error) -> Void in
            if !success {
                // Perform proper error handling here...
                print("*** An error occurred while saving the workout")
//                abort()
            }
            
            let stepsType =
            HKObjectType.quantityTypeForIdentifier(
                HKQuantityTypeIdentifierStepCount)
            
            let stepsQuantity = HKQuantity(unit: HKUnit.countUnit(),
                doubleValue: steps)
            
            let stepsSample =
            HKQuantitySample(type: stepsType!, quantity: stepsQuantity,
                startDate: startDate, endDate: endDate)
            
            var samples = [HKSample]()
            samples.append(stepsSample)
            
            // Continue adding detailed samples...
            
            // Add all the samples to the workout.
            self.healthKitStore.addSamples(samples,
                toWorkout: walk) { (success, error) -> Void in
                    
                    if !success {
                        // Perform proper error handling here...
                        print("*** An error occurred while adding a sample to the workout")
                        //abort()
                    }
                    print("Steps samples added to workout")
            }
        }
    }
    
    func saveRunningWorkout(startDate:NSDate , endDate:NSDate , distance:Double, distanceUnit:HKUnit , kiloCalories:Double,
        completion: ( (Bool, NSError!) -> Void)!) {
            
            // 1. Create quantities for the distance and energy burned
            let distanceQuantity = HKQuantity(unit: distanceUnit, doubleValue: distance)
            let caloriesQuantity = HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue: kiloCalories)
            
            // 2. Save Running Workout
            let workout = HKWorkout(activityType: HKWorkoutActivityType.Running, startDate: startDate, endDate: endDate, duration: abs(endDate.timeIntervalSinceDate(startDate)), totalEnergyBurned: caloriesQuantity, totalDistance: distanceQuantity, metadata: nil)
            healthKitStore.saveObject(workout, withCompletion: { (success, error) -> Void in
                if( error != nil  ) {
                    // Error saving the workout
                    completion(success,error)
                }
                else {
                    // if success, then save the associated samples so that they appear in the HealthKit
                    let distanceSample = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!, quantity: distanceQuantity, startDate: startDate, endDate: endDate)
                    let caloriesSample = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!, quantity: caloriesQuantity, startDate: startDate, endDate: endDate)
                    
                    self.healthKitStore.addSamples([distanceSample,caloriesSample], toWorkout: workout, completion: { (success, error ) -> Void in
                        completion(success, error)
                    })
                    
                }
            })
            
    }
    
    func readRecentlyWeekRunningWorkOuts(startDate:NSDate , endDate:NSDate, completion: (([AnyObject]!, NSError!) -> Void)!) {
        
        // 1. Predicate to read only running workouts
        //let predicate =  HKQuery.predicateForWorkoutsWithWorkoutActivityType(HKWorkoutActivityType.Running)
        //let predicate1 =  HKQuery.predicateForWorkoutsWithWorkoutActivityType(HKWorkoutActivityType.Walking)
        // 2. Order the workouts by date

//        let date = NSDate()
//        let dateFormatter = NSDateFormatter()
//        let timeZone = NSTimeZone(name: "UTC")
//        
//        dateFormatter.timeZone = timeZone
//        
//        print(dateFormatter.stringFromDate(date))
        
        print(startDate)
        print(endDate)
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate:endDate, options: .None)
        
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. Create the query
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate:mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor])
            { (sampleQuery, results, error ) -> Void in
                
                if let queryError = error {
                    print("There was an error while reading the samples: \(queryError.localizedDescription)")
                }
                completion(results,error)
        }
        
        realTimeQueries.append(sampleQuery)
        
        // 4. Execute the query
        healthKitStore.executeQuery(sampleQuery)
        
    }
    
    func fetchAvagageHeartRateHandle(startDate:NSDate , endDate:NSDate,
        completionHandler:(Double?, NSError?)->()) {
        let sampleType : HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
        let predicate : NSPredicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: HKQueryOptions.StrictStartDate)
        
            let squery = HKStatisticsQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: HKStatisticsOptions.DiscreteAverage, completionHandler: { (qurt, result, error) -> Void in
                
                if error != nil {
                    completionHandler(nil, error)
                    return
                }
                
                var beats:Double = 0.0
                
                if let quantity1 = result!.averageQuantity()
                {
                    beats = quantity1.doubleValueForUnit(HKUnit(fromString: "count/min"))
                }
                
                completionHandler(beats, error)
            })
        
        realTimeQueries.append(squery)
        healthKitStore.executeQuery(squery)
    }
    
    func fetchTotalJoulesConsumedWithCompletionHandler(
        completionHandler:(Double?, NSError?)->()) {
            
            let calendar = NSCalendar.currentCalendar()
            let now = NSDate()
            let components = calendar.components([NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Year], fromDate: now)
            
            let startDate = calendar.dateFromComponents(components)
            
            let endDate = calendar.dateByAddingUnit(NSCalendarUnit.Day,
                value: 1, toDate: startDate!, options:[])
            
            let sampleType = HKQuantityType.quantityTypeForIdentifier(
                HKQuantityTypeIdentifierDietaryEnergyConsumed)
            
            let predicate = HKQuery.predicateForSamplesWithStartDate(startDate,
                endDate: endDate, options: .StrictStartDate)
            
            let query = HKStatisticsQuery(quantityType: sampleType!,
                quantitySamplePredicate: predicate,
                options: .CumulativeSum) { query, result, error in
                    
                    if result != nil {
                        completionHandler(nil, error)
                        return
                    }
                    
                    var totalCalories = 0.0
                    
                    if let quantity = result!.sumQuantity() {
                        let unit = HKUnit.jouleUnit()
                        totalCalories = quantity.doubleValueForUnit(unit)
                    }
                    
                    completionHandler(totalCalories, error)
            }
            
            realTimeQueries.append(query)
            healthKitStore.executeQuery(query)
    }
    
    func readHeartRateWorkOuts(startDate:NSDate , endDate:NSDate, completion: (([AnyObject]!, NSError!) -> Void)!) {
        
        // 1. Predicate to read only running workouts
        //let predicate =  HKQuery.predicateForWorkoutsWithWorkoutActivityType(HKWorkoutActivityType.Running)
        //let predicate1 =  HKQuery.predicateForWorkoutsWithWorkoutActivityType(HKWorkoutActivityType.Walking)
        // 2. Order the workouts by date
    
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate:endDate, options: .None)
        
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. Create the query
        let sampleQuery = HKSampleQuery(sampleType: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!, predicate:mostRecentPredicate, limit: 0, sortDescriptors: [sortDescriptor])
            { (sampleQuery, results, error ) -> Void in
                
                if let queryError = error {
                    print("There was an error while reading the samples: \(queryError.localizedDescription)")
                }
                completion(results,error)
        }
        
        realTimeQueries.append(sampleQuery)
        
        // 4. Execute the query
        healthKitStore.executeQuery(sampleQuery)
    }
    
}