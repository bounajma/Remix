//  Copyright © 2017 cutting.io. All rights reserved.

import Foundation

protocol CategorySelectionCoordinatorDelegate: class {
    func didSelect(categoryID: CategoryID?)
    func didCancelSelection()
}

struct CategorySelectionDependencies: CategorySelectionCoordinator.Dependencies {
    let navigationCoordinator: NavigationCoordinator
    let categorySelectionListViewWireframe: CategorySelectionListViewWireframe
}

class CategorySelectionCoordinator {

    typealias Dependencies = HasNavigationCoordinator & HasCategorySelectionListViewWireframe

    private let dependencies: Dependencies
    private let categorySelectionInteractor = CategorySelectionInteractor()
    private let categorySelectionListFormatter = CategorySelectionListFormatter()

    private var rootCategorySelectionListView: CategorySelectionListView?

    weak var delegate: CategorySelectionCoordinatorDelegate?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func start() {
        rootCategorySelectionListView = pushAndUpdateCategorySelectionList()
    }

    @discardableResult private func pushAndUpdateCategorySelectionList(for categoryID: CategoryID? = nil) -> CategorySelectionListView {
        let categorySelectionListView = dependencies.categorySelectionListViewWireframe.make()
        categorySelectionListView.delegate = self
        dependencies.navigationCoordinator.push(view: categorySelectionListView)
        update(categorySelectionListView: categorySelectionListView, parentCategoryID: categoryID)
        return categorySelectionListView
    }

    private func update(categorySelectionListView: CategorySelectionListView, parentCategoryID: CategoryID?) {
        let view = categorySelectionListView
        categorySelectionInteractor.fetchCategories(parentCategoryID: parentCategoryID) { categories in
            let viewData = categorySelectionListFormatter.prepare(categories: categories)
            view.viewData = viewData
        }
    }
}

extension CategorySelectionCoordinator: CategorySelectionListViewDelegate {

    func didSelect(categoryID: CategoryID) {
        categorySelectionInteractor.findSelectionType(for: categoryID) { selectionType in
            switch selectionType {
            case .leafCategory:
                delegate?.didSelect(categoryID: categoryID)
            case .parentCategory:
                pushAndUpdateCategorySelectionList(for: categoryID)
            }
        }
    }

    func didDeselectAll() {
        delegate?.didSelect(categoryID: nil)
    }

    func didAbortSelection(view: CategorySelectionListView) {
        if view === rootCategorySelectionListView {
            delegate?.didCancelSelection()
        }
    }
}
