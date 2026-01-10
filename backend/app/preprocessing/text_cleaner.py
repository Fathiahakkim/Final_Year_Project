import re
import pandas as pd


def clean_text(text: str) -> str:
    """
    Apply minimal text cleaning to preserve sentence structure.
    MUST match training preprocessing exactly.
    """
    if pd.isna(text) or not isinstance(text, str):
        return text

    cleaned = text

    # Remove NHTSA markers (e.g., *TR, *JB, *BF, *JS, *SMD, *DT*JB, TL*)
    cleaned = re.sub(r'\bTL\*\s*', ' ', cleaned, flags=re.IGNORECASE)
    cleaned = re.sub(
        r'\s*\*[A-Z]{1,4}(?:\*[A-Z]{1,4})*\s*',
        ' ',
        cleaned,
        flags=re.IGNORECASE
    )

    # Convert to lowercase (after removing markers)
    cleaned = cleaned.lower()

    # Remove numeric dates (MM/DD/YYYY, M/D/YY, etc.)
    cleaned = re.sub(
        r'\b\d{1,2}[/-]\d{1,2}[/-]\d{2,4}\b',
        ' ',
        cleaned
    )

    # Remove VIN-like alphanumeric tokens (>10 chars AND contains digit)
    def replace_long_alnum(match):
        token = match.group(0)
        if len(token) > 10 and any(c.isdigit() for c in token):
            return ' '
        return token

    cleaned = re.sub(
        r'\b[A-Z0-9][A-Z0-9.\-]{9,}\b',
        replace_long_alnum,
        cleaned,
        flags=re.IGNORECASE
    )

    # Normalize whitespace
    cleaned = re.sub(r'\s+', ' ', cleaned).strip()

    return cleaned


if __name__ == "__main__":
    sample = "TL* THE VEHICLE EXPERIENCED ENGINE FAILURE ON 6/30/2015 VIN 1HGCM82633A123456"
    print("BEFORE:", sample)
    print("AFTER :", clean_text(sample))
