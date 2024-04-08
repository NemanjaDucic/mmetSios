import UIKit
import Foundation
class OnboardingPage1ViewController: UIViewController {
    
    var pageNumber = 1
    let transition = CATransition()

    
    let yellowBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 228/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "placeholder_profile")
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Мишо Вујовић"
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Oснивач је Мисије, сада Задужбине Манастира Хиландара у Београду, којом је руководио три године. Такође је оснивач Издавачке куће „Принцип Прес“ и престижног магазина Србија – Национална ревија.\n \nПриређивач је капиталних монографија на више светских језика: Туристичка библија Србије, Србија – од злата јабука, Бој изнад векова – стогодишњица Кумановске битке, Србија – друмовима, пругама, рекама и др.\n \n Руководилац је више пројеката из области културе, међу којима су значајнији „Србија на међународним сајмовима књига – Лајпциг, Пекинг, Москва, Франкфурт 2019“ као и подухват дигитализације културног наслеђа и савременог стваралаштва „Србија национална ревија — пут у дигитализовани свет културне баштине Србије“"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.preferredCurrentPageIndicatorImage = UIImage(named: "oval_indicator")
        pageControl.pageIndicatorTintColor = .red
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("СЛЕДЕЋЕ", for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(OnboardingPage1ViewController.self, action: #selector(nextPageButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        button.center.x = view.center.x
        button.center = self.view.center
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipeGesture(_:)))
        swipeGestureRight.direction = .right
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .left
        view.addGestureRecognizer(swipeGesture)
        view.addGestureRecognizer(swipeGestureRight)
        view.addSubview(yellowBackgroundView)
        yellowBackgroundView.addSubview(imageView)
        yellowBackgroundView.addSubview(titleLabel)
        yellowBackgroundView.addSubview(descriptionLabel)
        view.addSubview(pageControl)
        view.addSubview(button)
        
        
        NSLayoutConstraint.activate([
            yellowBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1),
            yellowBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.1),
            yellowBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width * 0.1),
            yellowBackgroundView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -view.frame.height * 0.1),
            
            imageView.topAnchor.constraint(equalTo: yellowBackgroundView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: yellowBackgroundView.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 73),
            imageView.heightAnchor.constraint(equalToConstant: 73),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: yellowBackgroundView.trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: yellowBackgroundView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: yellowBackgroundView.trailingAnchor, constant: -10),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -10),
            
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.35),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width * 0.35),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height * 0.1),
            button.heightAnchor.constraint(equalToConstant: 35),
            
        ])
        
    }
    @objc func nextPageButtonTapped() {
        pageNumber += 1
        transition.duration = 0.5
        transition.type = .moveIn
        if pageNumber == 2 {
            descriptionLabel.layer.add(transition, forKey: kCATransition)
            imageView.layer.add(transition, forKey: kCATransition)
            titleLabel.layer.add(transition, forKey: kCATransition)
            descriptionLabel.text = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less \n\nnormal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many\n \n web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."
            pageControl.currentPage = 1
            imageView.image = nil
            titleLabel.text = "Мишо Вујовић"

        }
        if pageNumber == 3 {
            descriptionLabel.layer.add(transition, forKey: kCATransition)
            imageView.layer.add(transition, forKey: kCATransition)
            titleLabel.layer.add(transition, forKey: kCATransition)
            descriptionLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer\n \n took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing\n 'n Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
            pageControl.currentPage = 2
            imageView.image = nil
            titleLabel.text = ""
        } else {
            //TO Seagues
        }
    }
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .moveIn
        if pageNumber < 4{
            pageNumber += 1
            if pageNumber == 1 {
                descriptionLabel.layer.add(transition, forKey: kCATransition)
                imageView.layer.add(transition, forKey: kCATransition)
                titleLabel.layer.add(transition, forKey: kCATransition)
                descriptionLabel.text = "Oснивач је Мисије, сада Задужбине Манастира Хиландара у Београду, којом је руководио три године. Такође је оснивач Издавачке куће „Принцип Прес“ и престижног магазина Србија – Национална ревија.\n \nПриређивач је капиталних монографија на више светских језика: Туристичка библија Србије, Србија – од злата јабука, Бој изнад векова – стогодишњица Кумановске битке, Србија – друмовима, пругама, рекама и др.\n \n Руководилац је више пројеката из области културе, међу којима су значајнији „Србија на међународним сајмовима књига – Лајпциг, Пекинг, Москва, Франкфурт 2019“ као и подухват дигитализације културног наслеђа и савременог стваралаштва „Србија национална ревија — пут у дигитализовани свет културне баштине Србије“"
                pageControl.currentPage = 0
                imageView.image = UIImage(named: "profile_placeholder")
                titleLabel.text = "Мишо Вујовић"

            }
            if pageNumber == 2 {
                descriptionLabel.layer.add(transition, forKey: kCATransition)

                descriptionLabel.text = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less \n\nnormal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many\n \n web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."
                pageControl.currentPage = 1
                titleLabel.text = ""
                imageView.image = nil

            }
            if pageNumber == 3 {
                descriptionLabel.layer.add(transition, forKey: kCATransition)

                descriptionLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer\n \n took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing\n 'n Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
                pageControl.currentPage = 2
                imageView.isHidden = true
                titleLabel.text = ""
                
            } else {
                //TO Seagues
            }
            
        }
    }
    @objc func handleRightSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .push
        if pageNumber > 1 {
            pageNumber -= 1
            if pageNumber == 1 {
                imageView.layer.add(transition, forKey: kCATransition)
                titleLabel.layer.add(transition, forKey: kCATransition)
                descriptionLabel.layer.add(transition, forKey: kCATransition)
                descriptionLabel.text = "Oснивач је Мисије, сада Задужбине Манастира Хиландара у Београду, којом је руководио три године. Такође је оснивач Издавачке куће „Принцип Прес“ и престижног магазина Србија – Национална ревија.\n \nПриређивач је капиталних монографија на више светских језика: Туристичка библија Србије, Србија – од злата јабука, Бој изнад векова – стогодишњица Кумановске битке, Србија – друмовима, пругама, рекама и др.\n \n Руководилац је више пројеката из области културе, међу којима су значајнији „Србија на међународним сајмовима књига – Лајпциг, Пекинг, Москва, Франкфурт 2019“ као и подухват дигитализације културног наслеђа и савременог стваралаштва „Србија национална ревија — пут у дигитализовани свет културне баштине Србије“"
                pageControl.currentPage = 0
                imageView.isHidden = false
                imageView.image = UIImage(named: "placeholder_profile")
                titleLabel.text = "Мишо Вујовић"

            }
            if pageNumber == 2 {
                descriptionLabel.layer.add(transition, forKey: kCATransition)

                descriptionLabel.text = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less \n\nnormal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many\n \n web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."
                pageControl.currentPage = 1
                imageView.isHidden = true
                titleLabel.text = ""
            }
            if pageNumber == 3 {
                descriptionLabel.layer.add(transition, forKey: kCATransition)

                descriptionLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer\n \n took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing\n 'n Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
                pageControl.currentPage = 2
                imageView.image = nil
                titleLabel.text = ""
            } else {
                //TO Seagues
            }}
    }
    
}
