import { Processor, WorkerHost } from '@nestjs/bullmq';
import { Job } from 'bullmq';
import { AwsS3Service } from '../services/aws-s3.service';
import { VideoService } from '@/modules/video/video.service';
import * as fs from 'fs';
@Processor('upload-s3')
export class UploadS3Processor extends WorkerHost {
  constructor(
    private readonly s3: AwsS3Service,
    private readonly videoService: VideoService,
  ) {
    super();
  }

  async process(job: Job, token?: string): Promise<any> {
    switch (job.name) {
      case 'upload':
        try {
          const s3url = await this.s3.uploadVideoFromPath(job.data.path);
          const updateVideo = await this.videoService.uploadVideoUrlS3(job.data.videoId, s3url);
          if (!s3url || !updateVideo) {
            return false;
          }
          return true;
        } catch (error) {
          console.log('error process', error);
        } finally {
          fs.unlinkSync(job.data.path);
        }
        break;
      default:
        throw new Error('No job name match');
    }
  }
}
