import XCTest
@testable import letterise

final class LetterPackTests: XCTestCase {
    
    private var sut: LetterPackChecker!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_letter_pack_init_success() {
        // given
        let letters: [Character] = ["a", "r", "a", "r", "a"]
        
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
        let letters: [Character] = ["a", "r", "a", "r", "a"]
        
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
        let letters: [Character] = ["c", "a", "r", "o"]
        
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
