import UIKit

final class WishMakerViewController: UIViewController {
    private let model = BackgroundColorModel()
    private var slidersStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = model.color
        configureTitle()
        configureDescription()
        configureSliders()
        configureButtonsStack()
    }

    // MARK: - Title & Description

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

    // MARK: - Sliders

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
            self?.model.update(red: CGFloat(value))
            self?.updateBackgroundColor()
        }
        sliderGreen.valueChanged = { [weak self] value in
            self?.model.update(green: CGFloat(value))
            self?.updateBackgroundColor()
        }
        sliderBlue.valueChanged = { [weak self] value in
            self?.model.update(blue: CGFloat(value))
            self?.updateBackgroundColor()
        }
    }

    // MARK: - Buttons

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

    // MARK: - Actions

    private func updateBackgroundColor() {
        view.backgroundColor = model.color
    }

    @objc private func toggleSliders() {
        slidersStack.isHidden.toggle()
    }

    @objc private func applyRandomColor() {
        model.randomize()
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
