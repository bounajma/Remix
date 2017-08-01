//  Copyright © 2017 cutting.io. All rights reserved.

import Foundation
import Wireframe
import Services

class AutoGroupInsertionFeature: InsertionFeature {

    struct Dependencies {
        let advertService: AdvertService
        let groupRecommendationService: GroupRecommendationService
        let textEntryStepViewFactory: TextEntryStepViewFactory
    }

    private let deps: Dependencies

    init(dependencies: Dependencies) {
        deps = dependencies
    }

    func makeCoordinatorUsing(navigationWireframe: NavigationWireframe) -> InsertionCoordinator {
        let coordinatorDeps = AutoGroupInsertionCoordinator.Dependencies(
            navigationWireframe: navigationWireframe,
            insertionInteractor: makeInteractor(),
            titleStepFormatter: makeTitleStepFormatter(),
            textEntryStepViewFactory: deps.textEntryStepViewFactory
        )
        return AutoGroupInsertionCoordinator(dependencies: coordinatorDeps)
    }

    private func makeInteractor() -> AutoGroupInsertionInteractor {
        let insertionInteractor = InsertionInteractor(advertService: deps.advertService)
        return AutoGroupInsertionInteractor(
            insertionInteractor: insertionInteractor,
            groupRecommendationService: deps.groupRecommendationService
        )
    }

    private func makeTitleStepFormatter() -> TitleStepFormatter {
        return TitleStepFormatter()
    }
}