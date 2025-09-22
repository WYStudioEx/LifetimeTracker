//
//  ViewController.swift
//  LifetimeTracker
//
//  Created by Krzysztof Zablocki on 07/31/2017.
//  Copyright (c) 2017 Krzysztof Zablocki. All rights reserved.
//

import UIKit
import LifetimeTracker

// MARK: - DetailItem -

class DetailItem: LifetimeTrackable {

    class var lifetimeConfiguration: LifetimeConfiguration {
        // There can be up to three 3 instances from the class. But only three in total including the subclasses
        return LifetimeConfiguration(maxCount: 3, groupName: "Detail Item", groupMaxCount: 3)
    }

    init() {
        self.trackLifetime()
    }
}

// fengchiwei 最多支持到两层，界面的上只能显示到 "Warrper Detail Item" 跟 其子类，不能处理到 DetailItem
// 的 "Detail Item" 组, 其实跟继承关系无关，底层无法监控继承关系的，都是获取对象的 lifetimeConfiguration 处理，
// 里面有 groupName 代表是在某个组里面，可以控制组的上线，也可以控制某个对象的上限,
// groupName 很容易让人误会是基类，其实没啥关系。
class WarrperDetailItem: DetailItem {

    override class var lifetimeConfiguration: LifetimeConfiguration {
        // There can be up to three 3 instances from the class. But only three in total including the subclasses
        return LifetimeConfiguration(maxCount: 6, groupName: "Warrper Detail Item", groupMaxCount: 30)
    }
}

// MARK: - DetailItem Subclasses

class AudtioDetailItem: WarrperDetailItem { }

class ImageDetailItem: WarrperDetailItem {
    override class var lifetimeConfiguration: LifetimeConfiguration {
        // There should only be one video item as the memory usage is too high
        let configuration = super.lifetimeConfiguration
        configuration.maxCount = 1
        return configuration
    }
}

class VideoDetailItem: ImageDetailItem {

    
}

// MARK: - ViewController -

var leakStorage = [AnyObject]()

class ViewController: UIViewController, LifetimeTrackable {
    
    static var lifetimeConfiguration = LifetimeConfiguration(maxCount: 2, groupName: "VC")

    // MARK: - Initialization

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        trackLifetime()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        trackLifetime()
    }

    // MARK: - IBActions

    @IBAction func createLeak(_ sender: Any) {
                     
        leakStorage.append(ViewController())

        leakStorage.append(AudtioDetailItem())
        leakStorage.append(ImageDetailItem())
        leakStorage.append(VideoDetailItem())
    }

    @IBAction func removeLeaks(_ sender: Any) {
        leakStorage.removeAll()
    }
}
