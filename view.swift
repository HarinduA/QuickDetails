import UIKit

// Define the model for items
struct Item {
    let name: String
    let detail: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items: [Item] = [
        Item(name: "Item 1", detail: "This is the detail for item 1."),
        Item(name: "Item 2", detail: "This is the detail for item 2.")
    ]
    
    // MARK: - UI Elements
    
    var tableView: UITableView!
    var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        title = "Items"
        
        // Set up the table view
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        // Set up the add button
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        showDetailViewController(for: selectedItem)
    }
    
    // MARK: - Navigation
    
    @objc func addItemButtonTapped() {
        showAddItemViewController()
    }
    
    func showDetailViewController(for item: Item) {
        let detailVC = DetailViewController(item: item)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func showAddItemViewController() {
        let addItemVC = AddItemViewController()
        addItemVC.delegate = self
        let navigationController = UINavigationController(rootViewController: addItemVC)
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - AddItemViewControllerDelegate

extension ViewController: AddItemViewControllerDelegate {
    func didAddNewItem(_ item: Item) {
        items.append(item)
        tableView.reloadData()
    }
}

// MARK: - DetailViewController

class DetailViewController: UIViewController {
    
    var item: Item
    
    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = item.name
        
        let detailLabel = UILabel()
        detailLabel.text = item.detail
        detailLabel.textAlignment = .center
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
            detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - AddItemViewController

protocol AddItemViewControllerDelegate: AnyObject {
    func didAddNewItem(_ item: Item)
}

class AddItemViewController: UIViewController {
    
    weak var delegate: AddItemViewControllerDelegate?
    
    var nameTextField: UITextField!
    var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Add New Item"
        
        // Set up the text field
        nameTextField = UITextField()
        nameTextField.placeholder = "Enter item name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        // Set up the add button
        addButton = UIButton(type: .system)
        addButton.setTitle("Add Item", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: 200),
            addButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func addButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        let newItem = Item(name: name, detail: "Details for \(name)")
        delegate?.didAddNewItem(newItem)
        dismiss(animated: true, completion: nil)
    }
}
