import UIKit

protocol MovieSearchViewDelegate: AnyObject {
    func movieSearchViewDidTapSearch(_ view: MovieSearchView)
}

class MovieSearchView: UIView {
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MovieFinder"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Encontre seus filmes favoritos"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Digite o nome do filme..."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buscar", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    weak var delegate: MovieSearchViewDelegate?
    
    var searchText: String? {
        return searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(searchTextField)
        addSubview(searchButton)
        addSubview(errorLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            
            // Subtitle Label
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            // Search Text Field
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            searchTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            searchTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Search Button
            searchButton.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            searchButton.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            searchButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Error Label
            errorLabel.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupActions() {
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        searchTextField.delegate = self
    }
    
    @objc private func searchButtonTapped() {
        let query = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !query.isEmpty else {
            showError("Por favor, digite o nome de um filme")
            return
        }
        hideError()
        delegate?.movieSearchViewDidTapSearch(self)
    }
    
    @objc private func textFieldDidChange() {
        hideError()
    }
    
    // MARK: - Public Methods
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func hideError() {
        errorLabel.isHidden = true
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        searchTextField.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension MovieSearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let query = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if !query.isEmpty {
            hideError()
            delegate?.movieSearchViewDidTapSearch(self)
        }
        
        textField.resignFirstResponder()
        return true
    }
}
