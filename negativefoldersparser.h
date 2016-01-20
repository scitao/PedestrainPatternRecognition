#ifndef NEGATIVEFOLDERSPARSER_H
#define NEGATIVEFOLDERSPARSER_H

#include <QString>
#include <QUrl>

#include <vector>

#include "patrec_types.h"

class NegativeFoldersParser
{

public:
    NegativeFoldersParser(QUrl rootFolder);

    pr::folder_vector *getFolders();

private:

    QUrl mRootFolder;
    QStringList mDataFolders;

};

#endif // NEGATIVEFOLDERSPARSER_H
