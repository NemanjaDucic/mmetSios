import UIKit
import Foundation

class MyPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
 private var counter = 0
    
 

    // Define your view controllers here
  
    let vc1 =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "slide1") as! Slide1ViewController
    let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "slide2") as! Slide2ViewController
    let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "slide3") as! Slide3ViewController

    // Define your page control here
    let pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the data source and delegate
        dataSource = self
        delegate = self
        
      
        NotificationCenter.default.addObserver(self, selector: #selector(self.nameOfFunction), name: NSNotification.Name(rawValue: "nameOfNotification"), object: nil)

        // Set the initial view controller
        setViewControllers([vc1], direction: .forward, animated: true, completion: nil)

        // Configure the page control
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .red
        pageControl.currentPageIndicatorTintColor = .red
        
        
        pageControl.preferredCurrentPageIndicatorImage = UIImage(named: "oval_indicator")
        pageControl.isUserInteractionEnabled = false
        view.addSubview(pageControl)
        
        // Add constraints to position the page control at the bottom of the view
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 40)
        ])
    }
    @objc func nameOfFunction(notif: NSNotification) {
        counter = pageControl.currentPage
        counter += 1
        if counter <= 2 {
            goToNextPageNow()
          pageControl.currentPage = pageControl.currentPage + 1
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "reg") as! RegisterViewController
            self.present(vc, animated: true)

        }
        
       
    }
    
    func goToNextPageNow() {
        guard let currentViewController = self.viewControllers?.first else {
            return
        }
        
        if let nextViewController = self.dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
            self.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == vc3 {
            return vc2
        } else if viewController == vc2 {
            return vc1
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == vc1 {
            return vc2
        } else if viewController == vc2 {
            return vc3
        } else {
            return nil
        }
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentVC = pageViewController.viewControllers?.first {
            if currentVC == vc1 {
                pageControl.currentPage = 0
            } else if currentVC == vc2 {
                pageControl.currentPage = 1
            } else {
                pageControl.currentPage = 2
            }
        }
    }
    
}

