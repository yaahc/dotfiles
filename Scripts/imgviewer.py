#! /bin/python2

import sys, os
from PyQt4 import QtGui, QtCore

# class Dialog(QtGui.QDialog):
#     def __init__(self, path):
#         QtGui.QDialog.__init__(self)
#         self.viewer = QtGui.QLabel(self)
#         self.viewer.setMinimumSize(QtCore.QSize(400, 400))
#         self.viewer.setScaledContents(True)
#         self.viewer.setPixmap(QtGui.QPixmap(path))
#         layout = QtGui.QVBoxLayout(self)
#         layout.addWidget(self.viewer)

#     def keyPressEvent(self, event):
#         if type(event) == QtGui.QKeyEvent:
#             print event.key()
#             event.accept()
#         else:
#             event.ignore()

class MainWindow(QtGui.QMainWindow):
    def __init__(self, path):
        QtGui.QMainWindow.__init__(self)
        self.viewer = QtGui.QLabel(self)
        self.viewer.setMinimumSize(QtCore.QSize(400, 400))
        self.viewer.setScaledContents(True)
        self.viewer.setPixmap(QtGui.QPixmap(path))
        layout = QtGui.QVBoxLayout(self)
        layout.addWidget(self.viewer)
        self.show()

    def keyPressEvent(self, event):
        if type(event) == QtGui.QKeyEvent:
            print event.key()
            event.accept()
        else:
            event.ignore()

if __name__ == '__main__':
    #argv should be a directory
    app = QtGui.QApplication(sys.argv)
    args = app.arguments()[1:]
    # if len(args) == 1:
        # dialog = Dialog(args[0])
    mainwindow = MainWindow(args[0])
    sys.exit(app.exec_())
        # if dialog.exec_() == QtGui.QDialog.Accepted:
        #     print dialog.editor.text().simplified().toLocal8Bit().data()
        #     sys.exit(0)
    # else:
    #     print 'ERROR: wrong number of arguments'
    # sys.exit(1)
