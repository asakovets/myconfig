import platform
import sys
from pathlib import Path

thisDir = Path(__file__).parent
isDryRun = "-n" in sys.argv
systemType = platform.system()

isLinux = systemType == "Linux"
isMac = systemType == "Darwin"
isWin = systemType == "Windows"

print(f"Dry run: {isDryRun}")
print(f"Repo dir: {thisDir}")


class Dir(str): pass


class File(str): pass


def doInst(src: Dir | File, dst: Dir | File) -> None:
    srcIsDir = isinstance(src, Dir)
    dstIsDir = isinstance(dst, Dir)

    if srcIsDir and not dstIsDir:
        raise ValueError(
            f"Directory source '{src}' requires a directory destination, got '{dst}'"
        )

    repoSrc = thisDir / src
    localDst = Path(dst).expanduser()

    sourcePaths = list(repoSrc.iterdir()) if srcIsDir else [repoSrc]

    for srcPath in sourcePaths:
        dstPath = localDst / srcPath.name if dstIsDir else localDst

        if isDryRun:
            print(f"  {dstPath} -> {srcPath}")
            continue

        dstPath.parent.mkdir(parents=True, exist_ok=True)
        try:
            dstPath.symlink_to(srcPath)
        except FileExistsError:
            pass
