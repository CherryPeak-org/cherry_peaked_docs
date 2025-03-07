//
//  CherryPeakedDocsPage.swift
//  cherry_peaked_docs
//
//  Created by Samuel Kubinský on 07/03/2025.
//

import VisionKit

struct CherryPeakedDocsPage {
    let id: String
    let image: UIImage
    
    static func extractFrom(_ scan: VNDocumentCameraScan) -> [CherryPeakedDocsPage] {
        (0 ..< scan.pageCount)
            .map { index in
                CherryPeakedDocsPage(
                    id: UUID().uuidString,
                    image: scan.imageOfPage(at: index)
                )
            }
    }
}
