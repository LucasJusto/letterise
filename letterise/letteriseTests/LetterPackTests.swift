import XCTest
@testable import letterise

final class LetterPackTests: XCTestCase {
    
    func test_letter_pack_init_success() {
        // given
        let letters: [Letter] = StringHandler.stringToLetters(from: "arara")
        
        let answers: [String] = ["arara", "ar", "ara", "ra", "rara"]
        
        // when
        do {
            let letterPack = try LetterPack(letters: letters, answers: answers)
            
            XCTAssertEqual(letterPack.letters, letters)
            XCTAssertEqual(letterPack.answers, answers)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_letter_pack_init_invalid_answers_error() {
        // given
        let letters: [Letter] = StringHandler.stringToLetters(from: "arara")
        
        let answers: [String] = ["arara", "ar", "aro", "ra", "rara"] // aro should fail for missing o at letters
        
        // when
        do {
            let _ = try LetterPack(letters: letters, answers: answers)
        } catch {
            if let letterPackError = error as? LetterPackError {
                XCTAssertEqual(letterPackError, .invalidAnswers)
            } else {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
    
    func test_letter_pack_init_with_two_equal_letters_invalid_answers_error() {
        // given
        let letters: [Letter] = StringHandler.stringToLetters(from: "caro")
        
        let answers: [String] = ["caro", "ar", "aro", "carro", "ra"] // carro should fail for missing one r at letters
        
        // when
        do {
            let _ = try LetterPack(letters: letters, answers: answers)
        } catch {
            if let letterPackError = error as? LetterPackError {
                XCTAssertEqual(letterPackError, .invalidAnswers)
            } else {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
    
}
