//  Copyright © 2017 cutting.io. All rights reserved.

import UIKit

class PrimeViewControllerFactory: PrimeViewFactory {

    func make() -> PrimeView {
        let storyboard = UIStoryboard(name: "PrimeViewController", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? PrimeViewController else { preconditionFailure() }
        return viewController
    }
}

class PrimeViewController: UIViewController, PrimeView {

    @IBOutlet weak var resultLabel: UILabel?

    weak var delegate: PrimeViewDelegate?
    var viewData: PrimeViewData? {
        didSet {
            updateView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
}

extension PrimeViewController {

    private func updateView() {
        guard isViewLoaded else { return }
        resultLabel?.text = viewData?.result
    }
}

extension PrimeViewController {

    @IBAction func didTapOK(_ sender: Any) {
        delegate?.didTapOK()
    }
}
