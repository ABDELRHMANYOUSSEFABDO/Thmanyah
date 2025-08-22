//
//  ContentTableViewCell.swift
//  Thmanyah
//
//  Created by Macbook on 21/08/2025.
//
import UIKit

final class ContentTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var viewCard: UIView!
    private var imageLoader: UIImageLoader?
    private var currentImageURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
        contentView.backgroundColor = .clear
        viewCard.layer.cornerRadius = 12
        viewCard.layer.masksToBounds = true
        
        
        backgroundColor = UIColor(AppTheme.bg)
        viewCard.backgroundColor = UIColor(AppTheme.card)
        
        imageLoader = UIImageLoader()
        setupImageLoaderBindings()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageLoader?.cancel()
        currentImageURL = nil
        
        thumbnailImageView?.image = UIImage(systemName: "photo.circle.fill")
        thumbnailImageView?.tintColor = UIColor(AppTheme.subtle)
        thumbnailImageView?.alpha = 0.5
        
        titleLabel?.text = nil
        descriptionLabel?.text = nil
    }
    
   
    private func setupImageLoaderBindings() {
        guard let imageLoader = imageLoader else { return }
        
        Task { @MainActor in
            for await _ in imageLoader.$isLoading.values {
                if imageLoader.isLoading {
                    thumbnailImageView.image = UIImage(systemName: "photo.circle.fill")
                    thumbnailImageView.tintColor = UIColor(AppTheme.subtle)
                    thumbnailImageView.alpha = 0.7
                } else {
                    thumbnailImageView.alpha = 1.0
                }
            }
        }
        
        Task { @MainActor in
            for await image in imageLoader.$image.values {
                if let image = image {
                    thumbnailImageView.image = image
                    thumbnailImageView.alpha = 1.0
                } else {
                    thumbnailImageView.image = UIImage(systemName: "photo.circle.fill")
                    thumbnailImageView.tintColor = UIColor(AppTheme.subtle)
                    thumbnailImageView.alpha = 0.5
                }
            }
        }
    }
    
    private func setupUI() {
        backgroundColor = UIColor(AppTheme.bg)
        selectionStyle = .none
        
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        contentView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 10
        thumbnailImageView.backgroundColor = UIColor(AppTheme.card)
        
        thumbnailImageView.image = UIImage(systemName: "photo.circle.fill")
        thumbnailImageView.tintColor = UIColor(AppTheme.subtle)
        thumbnailImageView.alpha = 0.5
        
        // تطبيق الخط العربي على العنوان
        if let titleFont = UIFont(name: "IBMPlexSansArabic-SemiBold", size: 18) {
            titleLabel.font = titleFont
        } else {
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
        titleLabel.textColor = UIColor(AppTheme.text)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        
        // تطبيق الخط العربي على الوصف
        if let descriptionFont = UIFont(name: "IBMPlexSansArabic-Regular", size: 14) {
            descriptionLabel.font = descriptionFont
        } else {
            descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        descriptionLabel.textColor = UIColor(AppTheme.subtle)
        descriptionLabel.numberOfLines = 3
        descriptionLabel.lineBreakMode = .byTruncatingTail
    }
    
    func configure(with item: ContentItem) {
        titleLabel?.text = item.title
        descriptionLabel?.text = item.subtitle ?? ""
        
        if let imageURL = item.imageURL {
            if currentImageURL != imageURL {
                imageLoader?.cancel()
                currentImageURL = imageURL
                
                thumbnailImageView?.image = UIImage(systemName: "photo.circle.fill")
                thumbnailImageView?.tintColor = UIColor(AppTheme.subtle)
                thumbnailImageView?.alpha = 0.7
                
                imageLoader?.load(from: imageURL)
            }
        } else {
            imageLoader?.cancel()
            currentImageURL = nil
            thumbnailImageView?.image = UIImage(systemName: "photo.circle.fill")
            thumbnailImageView?.tintColor = UIColor(AppTheme.subtle)
            thumbnailImageView?.alpha = 0.5
        }
    }
}

