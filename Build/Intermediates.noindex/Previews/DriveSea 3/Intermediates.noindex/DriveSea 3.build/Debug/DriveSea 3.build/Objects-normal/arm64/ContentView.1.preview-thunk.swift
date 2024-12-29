@_private(sourceFile: "ContentView.swift") import DriveSea_3
import func SwiftUI.__designTimeBoolean
import func SwiftUI.__designTimeInteger
import protocol SwiftUI.PreviewProvider
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeFloat
import struct SwiftUI.EmptyView
import protocol SwiftUI.View
import CoreData
import SwiftUI

extension ContentView {
    @_dynamicReplacement(for: deleteItems(offsets:)) private func __preview__deleteItems(offsets: IndexSet) {
        #sourceLocation(file: "/Volumes/RamDisk/DriveSea-3/DriveSea 3/ContentView.swift", line: 59)
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    
#sourceLocation()
    }
}

extension ContentView {
    @_dynamicReplacement(for: addItem()) private func __preview__addItem() {
        #sourceLocation(file: "/Volumes/RamDisk/DriveSea-3/DriveSea 3/ContentView.swift", line: 43)
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    
#sourceLocation()
    }
}

extension ContentView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Volumes/RamDisk/DriveSea-3/DriveSea 3/ContentView.swift", line: 20)
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label(__designTimeString("#387.[2].[2].property.[0].[0].arg[0].value.[0].modifier[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[0].arg[0].value", fallback: "Add Item"), systemImage: __designTimeString("#387.[2].[2].property.[0].[0].arg[0].value.[0].modifier[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[0].arg[1].value", fallback: "plus"))
                    }
                }
            }
            Text(__designTimeString("#387.[2].[2].property.[0].[0].arg[0].value.[1].arg[0].value", fallback: "Select an item"))
        }
    
#sourceLocation()
    }
}

import struct DriveSea_3.ContentView
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}



