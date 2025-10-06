import UIKit

enum Constants {
    static let titleLeading: CGFloat = 20
    static let titleTop: CGFloat = 30
    static let descriptionTop: CGFloat = 90
    static let descriptionLeading: CGFloat = 20
    static let descriptionTrailing: CGFloat = -20
    static let slidersStackLeading: CGFloat = 20
    static let slidersStackBottom: CGFloat = -220
    static let slidersCornerRadius: CGFloat = 12
    static let sliderMin: Double = 0
    static let sliderMax: Double = 1
    static let buttonHeight: CGFloat = 44
    static let buttonsStackBottom: CGFloat = -40
}

final class WishMakerViewController: UIViewController {
    private var red: CGFloat = 1
    private var green: CGFloat = 1
    private var blue: CGFloat = 1
    private var slidersStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .systemPink
        configureTitle()
        configureDescription()
        configureSliders()
        configureButtonsStack()
    }

    private func configureTitle() {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "WishMaker"
        title.font = .boldSystemFont(ofSize: 32)
        title.textColor = .white
        view.addSubview(title)
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.titleLeading),
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTop)
        ])
    }

    private func configureDescription() {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.text = "This app will bring you joy and will fulfill three of your wishes!\n\n• The first wish is to change the background color."
        description.font = .systemFont(ofSize: 16)
        description.textColor = .white
        description.numberOfLines = 0
        view.addSubview(description)
        NSLayoutConstraint.activate([
            description.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            description.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.descriptionLeading),
            description.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.descriptionTrailing),
            description.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.descriptionTop)
        ])
    }

    private func configureSliders() {
        slidersStack = UIStackView()
        slidersStack.translatesAutoresizingMaskIntoConstraints = false
        slidersStack.axis = .vertical
        slidersStack.spacing = 16
        slidersStack.backgroundColor = .white.withAlphaComponent(0.9)
        slidersStack.layer.cornerRadius = Constants.slidersCornerRadius
        slidersStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        slidersStack.isLayoutMarginsRelativeArrangement = true
        view.addSubview(slidersStack)

        let sliderRed = CustomSlider(title: "Red", min: Constants.sliderMin, max: Constants.sliderMax)
        let sliderGreen = CustomSlider(title: "Green", min: Constants.sliderMin, max: Constants.sliderMax)
        let sliderBlue = CustomSlider(title: "Blue", min: Constants.sliderMin, max: Constants.sliderMax)

        [sliderRed, sliderGreen, sliderBlue].forEach { slidersStack.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            slidersStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slidersStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.slidersStackLeading),
            slidersStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.slidersStackBottom)
        ])

        sliderRed.valueChanged = { [weak self] value in
            guard let self = self else { return }
            self.red = CGFloat(value)
            self.updateBackgroundColor()
        }
        sliderGreen.valueChanged = { [weak self] value in
            guard let self = self else { return }
            self.green = CGFloat(value)
            self.updateBackgroundColor()
        }
        sliderBlue.valueChanged = { [weak self] value in
            guard let self = self else { return }
            self.blue = CGFloat(value)
            self.updateBackgroundColor()
        }
    }

    private func configureButtonsStack() {
        let buttonsStack = UIStackView()
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 10
        view.addSubview(buttonsStack)

        let hexButton = createStyledButton(title: "Ввести HEX", action: #selector(openHexInput))
        let randomButton = createStyledButton(title: "Случайный цвет", action: #selector(applyRandomColor))
        let toggleButton = createStyledButton(title: "Показать/Скрыть слайдеры", action: #selector(toggleSliders))

        [hexButton, randomButton, toggleButton].forEach { buttonsStack.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.buttonsStackBottom),
            buttonsStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }

    private func createStyledButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func updateBackgroundColor() {
        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

    @objc private func toggleSliders() {
        slidersStack.isHidden.toggle()
    }

    @objc private func applyRandomColor() {
        red = CGFloat.random(in: 0...1)
        green = CGFloat.random(in: 0...1)
        blue = CGFloat.random(in: 0...1)
        updateBackgroundColor()
    }

    @objc private func openHexInput() {
        let alert = UIAlertController(title: "Введите HEX", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "#FF00FF" }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let hex = alert.textFields?.first?.text,
                  let color = UIColor(hex: hex) else { return }
            self?.view.backgroundColor = color
        })
        present(alert, animated: true)
    }
}

final class CustomSlider: UIView {
    var valueChanged: ((Double) -> Void)?
    var slider = UISlider()
    var titleView = UILabel()

    init(title: String, min: Double, max: Double) {
        super.init(frame: .zero)
        titleView.text = title
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("инициализатор не был реализован")
    }

    private func configureUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        for view in [slider, titleView] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            slider.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }

    @objc private func sliderValueChanged() {
        valueChanged?(Double(slider.value))
    }
}

// расширение для HEX
extension UIColor {
    convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") { hexString.removeFirst() }
        guard hexString.count == 6,
              let rgbValue = UInt64(hexString, radix: 16) else { return nil }
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
