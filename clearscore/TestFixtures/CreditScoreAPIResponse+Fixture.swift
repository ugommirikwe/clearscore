
extension CreditScoreAPIResponse {
    static func testFixture(
        accountIDVStatus: String = "PASS",
        creditReportInfo: CreditReportInfo = .testFixture(),
        dashboardStatus: String = "PASS",
        personaType: String = "INEXPERIENCED",
        coachingSummary: CoachingSummary = .testFixture(),
        augmentedCreditScore: Int? = nil
    ) -> Self {
        .init(
            accountIDVStatus: accountIDVStatus,
            creditReportInfo: creditReportInfo,
            dashboardStatus: dashboardStatus,
            personaType: personaType,
            coachingSummary: coachingSummary,
            augmentedCreditScore: augmentedCreditScore
        )
    }
}

extension CreditReportInfo {
    static func testFixture(
        /**TODO: Add arguments and default values for use in populating the fixture**/
    ) -> Self {
        .init(
            score: 434,
            scoreBand: 4,
            clientRef: "CS-SED-655426-708782",
            status: "MATCH",
            maxScoreValue: 700,
            minScoreValue: 0,
            monthsSinceLastDefaulted: -1,
            hasEverDefaulted: false,
            monthsSinceLastDelinquent: 1,
            hasEverBeenDelinquent: true,
            percentageCreditUsed: 44,
            percentageCreditUsedDirectionFlag: 1,
            changedScore: 0,
            currentShortTermDebt: 13758,
            currentShortTermNonPromotionalDebt: 13758,
            currentShortTermCreditLimit: 30600,
            currentShortTermCreditUtilisation: 44,
            changeInShortTermDebt: 549,
            currentLongTermDebt: 24682,
            currentLongTermNonPromotionalDebt: 24682,
            currentLongTermCreditLimit: nil,
            currentLongTermCreditUtilisation: nil,
            changeInLongTermDebt: -327,
            numPositiveScoreFactors: 9,
            numNegativeScoreFactors: 0,
            equifaxScoreBand: 4,
            equifaxScoreBandDescription: "Excellent",
            daysUntilNextReport: 9
        )
    }
}

extension CoachingSummary {
    static func testFixture(
        /**TODO: Add arguments and default values for use in populating the fixture**/
    ) -> Self {
        .init(
                activeTodo: false,
                activeChat: true,
                numberOfTodoItems: 0,
                numberOfCompletedTodoItems: 0,
                selected: true
            )
    }
}
