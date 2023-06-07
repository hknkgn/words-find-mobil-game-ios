import UIKit

class MatrixView: UIView {
    
    //let letters = ["A", "B", "C", "Ç", "D", "E", "F", "G", "Ğ", "H", "I", "İ", "J", "K", "L", "M", "N", "O", "Ö", "P", "R", "S", "Ş", "T", "U", "Ü", "V", "Y", "Z"]
    let letters = ["a", "b", "c", "ç", "d", "e", "f", "g", "ğ", "h", "ı", "i", "j", "k", "l", "m", "n", "o", "ö", "p", "r", "s", "ş", "t", "u", "ü", "v", "y", "z"]
    
    let colors = [UIColor.systemPink, UIColor.systemYellow, UIColor.systemGreen, UIColor.systemBlue, UIColor.systemOrange, UIColor.systemMint,UIColor.purple]
    
    let padding: CGFloat = 5.0
    
    var kelimeYokSayac = 0
    
    //harflerin puanları
    //let letterPoints = ["A": 1, "B": 3, "C": 4, "Ç": 4, "D": 3, "E": 1, "F": 7, "G": 5, "Ğ": 8, "H": 5, "I": 2, "İ": 1, "J": 10, "K": 1, "L": 1, "M": 2, "N": 1, "O": 2, "Ö": 7, "P": 5, "R": 1, "S": 2, "Ş": 4, "T": 1, "U": 2, "Ü": 3, "V": 7, "Y": 3, "Z": 4]
    let letterPoints = ["a": 1, "b": 3, "c": 4, "ç": 4, "d": 3, "e": 1, "f": 7, "g": 5, "ğ": 8, "h": 5, "ı": 2, "i": 1, "j": 10, "k": 1, "l": 1, "m": 2, "n": 1, "o": 2, "ö": 7, "p": 5, "r": 1, "s": 2, "ş": 4, "t": 1, "u": 2, "ü": 3, "v": 7, "y": 3, "z": 4]


    var wordTextField: UITextField!
    
    var cancelButton: UIButton!
    
    var confirmButton: UIButton!
    
    var timer: Timer?
    
    var titleLabel: UILabel!


   override init(frame: CGRect) {
        super.init(frame: frame)
        setupMatrix()
        setupWordInput()
    }

        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
 
    func setupMatrix() {
            
        // Hücre boyutunu ve matris boyutunu hesaplar
        let screenSize = UIScreen.main.bounds.size
        let totalPadding = padding * 6.0
        let cellSize = (screenSize.width - totalPadding) / 8.0
        let matrixWidth = screenSize.width - padding * 2.0
        let matrixHeight = cellSize * 11.0 + totalPadding + 420.0
        
          
        // Matris görünüm çerçevesini ayarlar
        let matrixFrame = CGRect(x: padding, y: padding + 100, width: matrixWidth, height: matrixHeight)
        self.frame = matrixFrame
        self.backgroundColor = UIColor.darkGray
        

        //Matris görünümüne hücre ekler
        for row in 0..<5 {
            for col in 0..<8 {
                let cellFrame = CGRect(x: CGFloat(col) * (cellSize + padding), y: CGFloat(row) * (cellSize + padding) + 420, width: cellSize, height: cellSize)
                let cellView = UIView(frame: cellFrame)
                cellView.backgroundColor = colors.randomElement()
                cellView.layer.cornerRadius = 5.0
                self.addSubview(cellView)
                
                let letterIndex = Int.random(in: 0..<letters.count)
                let letterLabel = UILabel(frame: CGRect(x: (cellSize - 20.0) / 2.0, y: (cellSize - 20.0) / 2.0, width: 20.0, height: 20.0))
                letterLabel.text = letters[letterIndex]
                letterLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
                letterLabel.textColor = UIColor.white
                letterLabel.textAlignment = .center
                cellView.addSubview(letterLabel)
                
                // Hücre görünümüne dokunma hareketi eklendi
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(letterTapped))
                cellView.addGestureRecognizer(tapGesture)
            }
            
        }
        
        
        //startTimer()

    }
    
    
    // harf yenilenme süresi
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.updateLetters()
        }
    }

    @objc func updateLetters() {
        for cellView in subviews where cellView is UIView {
            let letterIndex = Int.random(in: 0..<letters.count)
            if let letterLabel = cellView.subviews.first(where: { $0 is UILabel }) as? UILabel {
                letterLabel.text = letters[letterIndex]
            }
        }
    }


    /*@objc func letterTapped(_ sender: UITapGestureRecognizer) {
        guard let letterLabel = sender.view?.subviews.compactMap({ $0 as? UILabel }).first else {
            return
        }
        let letter = letterLabel.text ?? ""
        wordTextField.text?.append(letter)
        
       
        wordTextField.becomeFirstResponder()
        if let newPosition = wordTextField.position(from: wordTextField.endOfDocument, offset: 0) {
            wordTextField.selectedTextRange = wordTextField.textRange(from: newPosition, to: newPosition)
        }
        
        letterLabel.text = ""
    }*/
    @objc func letterTapped(_ sender: UITapGestureRecognizer) {
            // Tıklanan harf label'ını bul
            guard let letterLabel = sender.view?.subviews.compactMap({ $0 as? UILabel }).first else {
                return
            }
            
            // Tıklanan harf
            let letter = letterLabel.text ?? ""
            
            // Harfi metin kutusuna ekle
            wordTextField.text?.append(letter)
            
            // Tıklanan harfin rengini değiştir
            letterLabel.textColor = UIColor.darkGray
            
            // Tıklanan hücrenin rengini değiştir
            sender.view?.backgroundColor = UIColor.darkGray
            
            
            wordTextField.becomeFirstResponder()
            
         
            if let newPosition = wordTextField.position(from: wordTextField.endOfDocument, offset: 0) {
                wordTextField.selectedTextRange = wordTextField.textRange(from: newPosition, to: newPosition)
            }
        letterLabel.text = ""
        }


    
    func setupWordInput() {
        let screenSize = UIScreen.main.bounds.size
        let inputFrame = CGRect(x: padding, y: screenSize.height - 160.0, width: screenSize.width - padding * 2.0, height: 50.0)

        // Word input field
        wordTextField = UITextField(frame: inputFrame)
        wordTextField.placeholder = "..."
        wordTextField.textAlignment = .center
        //wordTextField.borderStyle = .roundedRect
        wordTextField.font = UIFont.systemFont(ofSize: 22.0, weight: .regular)
        wordTextField.textColor = UIColor.white
        wordTextField.backgroundColor = UIColor.darkGray
        //wordTextField.clearButtonMode = .whileEditing
        wordTextField.autocorrectionType = .no
    

        self.addSubview(wordTextField)
        
        
        let labelFrame = CGRect(x: padding, y: screenSize.height - 700.0, width: screenSize.width - padding * 2.0, height: 50.0)
        titleLabel = UILabel(frame: labelFrame)
        titleLabel.text = "KELİME OYUNU"
        titleLabel.font = UIFont(name: "GillSans-Bold", size: 40.0)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        
        
        self.addSubview(titleLabel)
        
        
        // Cancel button
        let cancelFrame = CGRect(x: inputFrame.minX + 10.0, y: UIScreen.main.bounds.maxY - 160.0, width: 50.0, height: 50.0)

        cancelButton = UIButton(frame: cancelFrame)
        cancelButton.setTitle("X", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.backgroundColor = UIColor.red
        cancelButton.layer.cornerRadius = 25.0
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.addSubview(cancelButton)

        
        // kontrol button
        let confirmFrame = CGRect(x: inputFrame.maxX - 80.0, y: UIScreen.main.bounds.maxY - 160.0, width: 50.0, height: 50.0)
        confirmButton = UIButton(frame: confirmFrame)
        confirmButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        confirmButton.tintColor = UIColor.white
        confirmButton.backgroundColor = UIColor.systemGreen
        confirmButton.layer.cornerRadius = 28.0
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        self.addSubview(confirmButton)

    }

    @objc func cancelButtonTapped() {
        let alertController = UIAlertController(title: "Emin misiniz?", message: "Girdiğiniz kelime kaydedilmeyecek.", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Evet", style: .destructive) { _ in
            self.wordTextField.text = ""
        }
        let noAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }


    @objc func confirmButtonTapped(_ sender: UITapGestureRecognizer){
        guard let word = wordTextField.text, !word.isEmpty else {
            return
        }
        if word.count < 3 {
            let alertController = UIAlertController(title: "Hata!", message: "En az 3 harfli kelime giriniz.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            return
        }
        else if(word.count>=3){
            updateLetters()
        }

        
        var score = 0
        
        for letter in word {
            if let point = letterPoints[String(letter).lowercased()] {
                score += point
            }
        }
        
            // Girilen kelimeyi tutma
            let enteredWord = word
            
            let kelimeVarMi = kelimeBul(enteredWord)
        
        if(kelimeVarMi == true){
            // Skoru ekrana yazdırma
            let alertController = UIAlertController(title: "KELİME BULUNDU!", message: "Kelimeniz \(score) puan kazandırdı! Kelime: \(enteredWord)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Oyuna Devam", style: .default, handler: nil)
            alertController.addAction(okAction)
            let finish = UIAlertAction(title: "Oyunu Bitir", style: .default, handler: { (_) in
                exit(0)
            })
            alertController.addAction(finish)
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            wordTextField.text = ""
            kelimeYokSayac = 0
            setupMatrix()
        }
        else{
            kelimeYokSayac += 1
            let alertController = UIAlertController(title: "KELİME BULUNAMADI!", message: "Bu Kelime Yoktur.\(kelimeYokSayac)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            
            wordTextField.text = ""
            
            if(kelimeYokSayac == 3)
            {
                let screenSize = UIScreen.main.bounds.size
                let totalPadding = padding * 6.0
                let cellSize = (screenSize.width - totalPadding) / 8.0
                
                for row in 0..<5 {
                    for col in 0..<8 {
                        let cellFrame = CGRect(x: CGFloat(col) * (cellSize + padding), y: CGFloat(row) * (cellSize + padding) + 420, width: cellSize, height: cellSize)
                        let cellView = UIView(frame: cellFrame)
                        cellView.backgroundColor = UIColor.darkGray
                        cellView.layer.cornerRadius = 5.0
                        self.addSubview(cellView)
                        
                        let letterIndex = Int.random(in: 0..<letters.count)
                        let letterLabel = UILabel(frame: CGRect(x: (cellSize - 20.0) / 2.0, y: (cellSize - 20.0) / 2.0, width: 20.0, height: 20.0))
                        letterLabel.text = letters[letterIndex]
                        letterLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
                        letterLabel.textColor = UIColor.darkGray
                        letterLabel.textAlignment = .center
                        cellView.addSubview(letterLabel)
                        wordTextField.text = "Harfler Düştü(3 Yanlış)"
                    }
                    
                }
            }
        }
}
    func kelimeBul(_ enteredWord: String) -> Bool {
        if let path = Bundle.main.path(forResource: "words", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let kelimeListesi = data.components(separatedBy: .newlines)
                return kelimeListesi.contains(enteredWord)
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        return false
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let matrixView = MatrixView(frame: self.view.bounds)
            self.view.addSubview(matrixView)
        
        // Set constraints for matrix view
             matrixView.translatesAutoresizingMaskIntoConstraints = false
             NSLayoutConstraint.activate([
                 matrixView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                 matrixView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                 matrixView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                 matrixView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
             ])
 
      
    }
    
}


