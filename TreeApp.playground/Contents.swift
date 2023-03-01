//

import SwiftUI

struct Node {
    var name: String
    var children: [Node] = []
    var parent: Node?
    
    init(name: String, parent: Node? = nil) {
        self.name = name
        self.parent = parent
    }
}

class TreeData: ObservableObject {
    @Published var rootNode = Node(name: "Root")
    
    func addChild(to node: Node) {
        let newNode = Node(name: "Child \(node.children.count + 1)", parent: node)
        node.children.append(newNode)
    }
    
    func removeChild(from node: Node, at index: Int) {
        node.children.remove(at: index)
    }
    
    func saveTree() {
       
    }
    
    func loadTree() {
        
    }
}

struct ContentView: View {
    @ObservedObject var treeData = TreeData()
    @State var currentNode: Node?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(currentNode?.children ?? treeData.rootNode.children, id: \.self) { child in
                    NavigationLink(destination: ContentView(treeData: treeData, currentNode: child)) {
                        Text(child.name)
                    }
                }
                .onDelete(perform: { indexSet in
                    if let node = currentNode {
                        for index in indexSet {
                            treeData.removeChild(from: node, at: index)
                        }
                    }
                })
            }
            .navigationBarTitle(currentNode?.name ?? "Root")
            .navigationBarItems(trailing: Button("Add") {
                if let node = currentNode {
                    treeData.addChild(to: node)
                } else {
                    treeData.addChild(to: treeData.rootNode)
                }
            })
        }
        .onAppear {
            if currentNode == nil {
                treeData.loadTree()
            }
        }
        .onDisappear {
            if currentNode == nil {
                treeData.saveTree()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(treeData: TreeData())
    }
}
