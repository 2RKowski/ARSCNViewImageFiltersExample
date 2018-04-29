//
//  ViewController.swift
//  ARSCNViewImageFiltersExample
//
//  Created by Lësha Turkowski on 4/29/18.
//  Copyright © 2018 Lësha Turkowski. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet var sceneView: ARSCNView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        let filterTechnique = makeTechnique(fromPlistNamed: "SceneFilterTechnique")
        sceneView.technique = filterTechnique
        
        addSampleObjects(to: scene)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - Private methods
    
    private func makeTechnique(fromPlistNamed plistName: String) -> SCNTechnique {
        guard let url = Bundle.main.url(forResource: plistName, withExtension: "plist") else {
            fatalError("\(plistName).plist does not exist in the main bundle")
        }
        
        guard let dictionary = NSDictionary(contentsOf: url) as? [String: Any] else {
            fatalError("Failed to parse \(plistName).plist as a dictionary")
        }
        
        guard let technique = SCNTechnique(dictionary: dictionary) else {
            fatalError("Failed to initialize a technique using \(plistName).plist")
        }
        
        return technique
    }
    
    private func addSampleObjects(to scene: SCNScene) {
        
        func sphere(color: UIColor, position: float3) -> SCNNode {
            let sphere = SCNSphere(radius: 0.1)
            sphere.firstMaterial!.diffuse.contents = color
            let node = SCNNode(geometry: sphere)
            node.simdPosition = position
            
            return node
        }
        
        let rootNode = scene.rootNode
        
        rootNode.addChildNode(sphere(color: .red, position: float3(-0.25, 0, 0)))
        rootNode.addChildNode(sphere(color: .green, position: float3(0, 0, 0)))
        rootNode.addChildNode(sphere(color: .blue, position: float3(0.25, 0, 0)))
        
    }
    
}
